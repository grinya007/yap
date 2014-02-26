var yap = {};
yap.init = function()
{
    yap.highlightJs = $('pre.show code');
    yap.codeMirror = CodeMirror($('div.input').get(0), {lineNumbers: true});
    $('div.save').click(yap.storePaste);
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
yap.showCodeMirror = function()
{
    $(yap.codeMirror.getWrapperElement()).parent().parent().show();
    yap.codeMirror.refresh();
};
yap.hideCodeMirror = function()
{
    $(yap.codeMirror.getWrapperElement()).parent().parent().hide();
};
yap.showTime = function(sContent, sHash)
{
    $('ul.history').children().removeClass('current');
    $('div.create').removeClass('current');
    $('li#'+sHash).addClass('current');
    yap.hideCodeMirror();
    yap.highlightJs.html(sContent); // escape me
    hljs.highlightBlock(yap.highlightJs.get(0));
    yap.highlightJs.parent().show();
    yap.refreshHistory();
};
yap.pasteTime = function()
{
    $('ul.history').children().removeClass('current');
    $('div.create').addClass('current');
    yap.highlightJs.parent().hide();
    yap.codeMirror.setValue('');
    yap.showCodeMirror();
    yap.refreshHistory();
};
yap.refreshHistory = function()
{
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
            $('<li id="'+row[1]+'"><a href="/#'+row[1]+'">'+row[0]+'</a></li>').
                hide().
                prependTo(seHistory).
                slideDown('fast');
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
$(yap.init);
