CREATE TYPE USER_MnozstviVJednotkach AS TABLE (
    [ArtJed_ID] [uniqueidentifier] NULL,
	[Kod] [varchar](10) NULL,
	[VychoziMnozstvi] [int] NULL,
	[Mnozstvi] [int] NULL,
	[MnozstviVychoziJednotka] [int] NULL,
	[JeVychoziJednotka] [bit] NULL
);