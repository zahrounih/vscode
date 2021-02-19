USE [LSSNG_hz]
GO

/****** Object:  Table [dbo].[LSSNG1_AL_A]    Script Date: 1/02/2021 16:30:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Flights](
	simId INT NOT NULL,
	ABISv INT NOT NULL,
	xfli1_ofsdtad datetime NULL,
	xfli1_coicao nvarchar (255) NULL, 
	xfli1_flnum INT NULL,
	xfli1_flopsfx nvarchar (255) NULL,
	xfli1_ofardep nvarchar (255) NULL,
	xfli_apiata nvarchar(255) NULL, 
	xfli_handler nvarchar (255) NULL,
	xfli_lstad datetime NULL,
	xfli_ofbkblk datetime NULL
) ON [PRIMARY]
GO

select * from flights

