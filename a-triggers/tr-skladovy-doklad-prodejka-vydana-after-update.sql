CREATE OR ALTER TRIGGER USER_SkladovyDoklad_ProdejkaVydana_AfterUpdate
ON SkladovyDoklad_ProdejkaVydana
AFTER UPDATE
AS
BEGIN
	
	-- aktualizovat finance-pokladni-doklad aby se spustil trigger na pokladni doklady (seky)
	UPDATE Ucetnictvi_InterniDoklad SET 
		ID = PD.ID
	FROM Ucetnictvi_InterniDoklad AS PD
	INNER JOIN inserted AS D ON PD.ParovaciSymbol = D.CisloDokladu;

END
