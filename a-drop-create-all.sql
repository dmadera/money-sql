
PRINT 'Dropping all objects.';
GO
:r \\tsclient\dmadera\projects\money-sql\a-drop-all.sql
GO
PRINT 'Creating objects from dir ./a-types.';
GO
:r \\tsclient\dmadera\projects\money-sql\a-types\type-user-mnozstvi-v-jednotkach.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-types\type-user-polozka-dokladu.sql
GO
PRINT 'Creating objects from dir ./a-views.';
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-artikly-baleni.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-artikly-kategorie.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-artikly-priznaky.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-artikly-sazba.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-polozky-ceniku.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-posledni-prijmy-zasoby.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-views\view-user-zasoby.sql
GO
PRINT 'Creating objects from dir ./a-procedures.';
GO
:r \\tsclient\dmadera\projects\money-sql\a-procedures\proc-user-import-fa-do-pohody.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-procedures\proc-user-mnozstvi-artiklu-v-jednotkach.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-procedures\proc-user-polozky-mnozstvi-v-jednotkach.sql
GO
PRINT 'Creating objects from dir ./a-triggers.';
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-adresar-firma-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-artikly-artikl-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-ceniky-polozka-ceniku-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-fakturace-polozka-faktury-prijate-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-objednavky-polozka-nabidky-vydane-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-objednavky-polozka-objednavky-prijate-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-objednavky-polozka-objednavky-vydane-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-skladovy-doklad-polozka-dodaciho-listu-prijateho-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-skladovy-doklad-polozka-dodaciho-listu-vydaneho-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-skladovy-doklad-polozka-prodejky-vydane-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-skladovy-doklad-prodejka-vydana-after-insert.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-skladovy-doklad-prodejka-vydana-after-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-sklady-stav-zasoby-after-insert-update.sql
GO
:r \\tsclient\dmadera\projects\money-sql\a-triggers\tr-ucetnictvi-interni-doklad-after-insert-update.sql
GO
