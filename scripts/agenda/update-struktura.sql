-- uvolni editaci nakupnich jednotek v katalogu
ALTER TABLE Obchod_ObsahPolozkySArtiklem 
	DROP CONSTRAINT FK_Obchod_ObsahPolozkySArtiklem_Artikly_ArtiklJednotka_Jednotka_ID;
ALTER TABLE Obchod_ObsahPolozkySArtiklem  WITH NOCHECK 
	ADD CONSTRAINT FK_Obchod_ObsahPolozkySArtiklem_Artikly_ArtiklJednotka_Jednotka_ID 
	FOREIGN KEY(Jednotka_ID)
	REFERENCES Artikly_ArtiklJednotka (ID)
	ON DELETE SET NULL;
ALTER TABLE Obchod_ObsahPolozkySArtiklem 
	CHECK CONSTRAINT FK_Obchod_ObsahPolozkySArtiklem_Artikly_ArtiklJednotka_Jednotka_ID;

-- smaze nepouzivane typy spojeni
DELETE FROM Adresar_TypSpojeni
where Nazev NOT LIKE '@%' AND Nazev NOT LIKE '#%';
