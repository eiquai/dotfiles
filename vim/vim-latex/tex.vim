:call IMAP('CAS',   '\autocite[<++>]{<+source+>}<++>', 'tex')
:call IMAP('CAL',   '\autocite[vgl.][<++>]{<+source+>}<++>', 'tex')

:call IMAP('ITM',   '\item <++>', 'tex')
:call IMAP('ITD',   '\item [ <++> ] <++>', 'tex')

:call IMAP('MRR',   '\marginpar{<++>}<++>','tex')

:call IMAP('FTN',   '\footnote{<++>}<++>', 'tex')

:call IMAP('TSK',   '\todo{<+task+>} <++>','tex')
:call IMAP('TLS',   '\listoftodos <++>', 'tex')

:call IMAP('CO²',   'CO\textsubscript{2}<++>',  'tex')

:call IMAP('URL',   '\url{<++>}<++>',  'tex')

imap <buffer> <leader>it <Plug>Tex_InsertItemOnThisLine
let g:Tex_SmartKeyQuote = 1
