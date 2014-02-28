var yap = {};
yap.init = function()
{
    CodeMirror.modeURL = '/js/codemirror-3.22/mode/%N/%N.js';
    yap.codeMirror = CodeMirror($('div.code').get(0), {lineNumbers: true});
    $('div.save').click(yap.storePaste);
    $(window).resize(yap.autoHeight);
    yap.autoHeight();
    $(window).on('hashchange', yap.locationHandler);
    if (window.location.hash) yap.locationHandler();
    else yap.pasteTime();
};
yap.locationHandler = function()
{
    var sHash = window.location.hash.replace(/^#/, '');
    if (/^[a-f0-9]{8}$/.test(sHash)) 
        $.get('/'+sHash, function (sContent) { yap.showTime(sContent, sHash) });
    else yap.pasteTime();
};
yap.autoHeight = function()
{
    iHeight = $(window).height() - 80;
    yap.codeMirror.setSize('auto', iHeight);
    $('ul.history').height(iHeight);
};
yap.showTime = function(sContent, sHash)
{
    yap.currentId = sHash;
    yap.refreshHistory();
    $('ul.history').children().removeClass('current');
    $('div.create').removeClass('current');
    $('li#'+sHash).addClass('current');
    $('div.raw > a').attr('href', '/'+sHash).show();
    $('div.save').css('color', 'grey');
    var sLang = hljs.highlightAuto(sContent).language || '';
    $('span.lang').text(sLang);
    sLang = yap.translateLang(sLang);
    yap.codeMirror.setOption('mode', sLang);
    CodeMirror.autoLoadMode(yap.codeMirror, sLang);
    yap.codeMirror.setValue(sContent);
};
yap.pasteTime = function()
{
    yap.refreshHistory();
    $('span.lang').text('');
    $('ul.history').children().removeClass('current');
    $('div.create').addClass('current');
    $('div.raw > a').hide();
    $('div.save').css('color', 'black');
    yap.codeMirror.setValue('');
    yap.codeMirror.setOption('mode', '');
};
yap.refreshHistory = function()
{
    // FIXME hell nesting
    $.get('/history', function(aHistory)
    {
        aHistory.sort(function(a,b)
        {
            return a[0] > b[0] ? 1 : -1;
        });
        var seHistory = $('ul.history');
        $.each(aHistory, function(i, row)
        {
            if ($('li#'+row[1]).get(0)) return;
            $(
                '<li id="'+row[1]+'"><a href="/#'+
                row[1]+'">'+yap.ts2date(row[0])+
                '</a><span class="delete" data-id="'+
                row[1]+'">&times;</span></li>'
            ).
            hide().
            addClass(function()
            {
                if (row[1] == yap.currentId) return 'current'
            }).
            prependTo(seHistory).
            slideDown('fast').
            find('span.delete').
            click(function()
            {
                var seLi = $(this).parent();
                var sId = $(this).data('id');
                $.ajax
                ({
                    url: '/'+sId,
                    method: 'DELETE',
                    success: function() 
                    {
                        if (seLi.hasClass('current')) 
                            window.location.hash = '#';
                        seLi.slideUp('fast', function() 
                        {
                            seLi.remove()
                        });
                    }
                });
            });
        });
    });
};
yap.storePaste = function()
{
    var sContent = yap.codeMirror.getValue();
    if (!sContent.length) return;
    $.post('/', {content: sContent}, function(sId)
    {
        if (!sId) return;
        window.location.hash = '#'+sId;
    }, 'text');
};
yap.ts2date = function(iTs)
{
    var oDateNow = new Date();
    var oDate = new Date((iTs - oDateNow.getTimezoneOffset() * 60) * 1000);
    return oDate.toISOString().replace('T', '&nbsp;').replace('.000Z', '');
};
yap.hljs2codeMirror = 
{
    cpp: 'clike',
    objectivec: 'clike',
    bash: 'shell',
    xml: 'htmlmixed'
};
yap.translateLang = function(sLang)
{
    if (sLang in yap.hljs2codeMirror) return yap.hljs2codeMirror[sLang];
    else return sLang;
};
$(yap.init);
