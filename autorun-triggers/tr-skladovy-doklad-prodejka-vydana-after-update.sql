CREATE OR ALTER TRIGGER TR_SkladovyDoklad_ProdejkaVydana_AfterUpdate
ON SkladovyDoklad_ProdejkaVydana
AFTER UPDATE
AS
BEGIN
	
	-- aktualizovat finance-pokladni-doklad aby se spustil trigger na pokladni doklady (seky)
	UPDATE Ucetnictvi_InterniDoklad SET 
		ID = PD.ID
	FROM Ucetnictvi_InterniDoklad AS PD
	INNER JOIN inserted AS PR ON PD.ParovaciSymbol = PR.CisloDokladu;
	
	IF Context_Info() = 0x55553
		RETURN; 

	UPDATE SkladovyDoklad_ProdejkaVydana SET
		Zaplaceno_UserData = CASE
			WHEN Platba.Kod = 'ZH' THEN 1
			WHEN Platba.Kod = 'ZK' THEN 1
			ELSE 0
		END
	FROM SkladovyDoklad_ProdejkaVydana AS Prodejka
	INNER JOIN inserted ON inserted.ID = Prodejka.ID
	INNER JOIN Ciselniky_ZpusobPlatby AS Platba ON Platba.ID = Prodejka.ZpusobPlatby_ID;

END
