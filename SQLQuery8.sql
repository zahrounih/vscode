USE [LSSNG_hz]
GO

/****** Object:  View [dbo].[vw_lssng1_AL_A_A]    Script Date: 3/02/2021 17:25:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


     CREATE VIEW [dbo].[vw_Allocs] AS
      SELECT [simId]
      ,[ABISv]
      ,[xalc1_sdt]
      ,[xalc1_coicao]
      ,[xalc1_flnum]
      ,[xalc1_flopsfx]
	  ,CONCAT(trim(xalc1_coicao),trim(xalc1_flnum),trim(xalc1_flopsfx)) AS Flight
      ,[xalc_sorstr]
      ,[xalc_dtfr]
      ,[xalc_dtto]
      ,[xalc_bie]
      ,[xalc_ch]
		FROM [dbo].[Allocs]

		select * from vw_allocs

		select convert(varchar,xalc1_sdt, 105) as sdt
		,Flight
		,xalc_sorstr
		,CONCAT(xalc_bie,xalc_ch) as chute
		,convert(varchar,xalc_dtfr, 20) as ch_open
		,convert(varchar,xalc_dtto, 20) as ch_close
		from vw_allocs
		where simid =103 and ABISv=1

      
GO


