
PRINT 'Dropping all objects.';
GO
:r D:\MoneyDev\MoneySql\a-drop-all.sql
GO
PRINT 'Creating objects from dir ./a1-types.';
GO
:r D:\MoneyDev\MoneySql\a1-types\type-user-mnozstvi-v-jednotkach.sql
GO
:r D:\MoneyDev\MoneySql\a1-types\type-user-polozka-dokladu.sql
GO
PRINT 'Creating objects from dir ./a1-views.';
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-baleni-karton.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-baleni.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-dph.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-jednotky.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-kategorie.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-priznaky.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-artikly-stitek.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-firmy-nevalidni-email.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-posledni-prijmy-zasoby.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-z-polozky-ceniku.sql
GO
:r D:\MoneyDev\MoneySql\a1-views\view-user-zasoby-prodej.sql
GO
PRINT 'Creating objects from dir ./a2-procedures.';
GO
:r D:\MoneyDev\MoneySql\a2-procedures\proc-user-katalog-jednotky.sql
GO
:r D:\MoneyDev\MoneySql\a2-procedures\proc-user-zasoba-prodejnost.sql
GO
PRINT 'Creating objects from dir ./a2-triggers.';
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-adresar-firma-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-artikly-artikl-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-artikly-artikl-jednotka-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-artikly-artikl-prod-klic-after-delete.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-artikly-artikl-prod-klic-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-ceniky-polozka-ceniku-after-delete.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-ceniky-polozka-ceniku-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-fakturace-polozka-faktury-vydane-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-objednavky-polozka-nabidky-vydane-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-objednavky-polozka-objednavky-prijate-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-skladovy-doklad-dodaci-list-vydany-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-skladovy-doklad-polozka-dodaciho-listu-prijateho-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-skladovy-doklad-polozka-dodaciho-listu-vydaneho-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-skladovy-doklad-polozka-prodejky-vydane-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-skladovy-doklad-prodejka-vydana-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-sklady-pohyb-zasoby-after-insert-update.sql
GO
:r D:\MoneyDev\MoneySql\a2-triggers\tr-ucetnictvi-interni-doklad-after-insert-update.sql
GO
