USE [QL_SV]
GO
/****** Object:  StoredProcedure [dbo].[sp_BangDiemTongKet_Report]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_BangDiemTongKet_Report]
@MALOP char(10)
AS
BEGIN
SELECT sv.MASV+'- '+HO+' '+TEN AS HOTEN,TENMH ,MAX(DIEM)AS DIEM 
FROM SINHVIEN sv,MONHOC mh,DIEM diem 
WHERE MALOP=@MALOP AND sv.MASV=diem.MASV  AND mh.MAMH=diem.MAMH AND sv.NGHIHOC='false'
GROUP BY sv.MASV,HO,TEN,TENMH
ORDER BY sv.TEN
END
GO
/****** Object:  StoredProcedure [dbo].[SP_DANGNHAP]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_DANGNHAP]
@TENLOGIN NVARCHAR (50)
AS
DECLARE @TENUSER NVARCHAR(50)
SELECT @TENUSER=NAME FROM sys.sysusers WHERE sid = SUSER_SID(@TENLOGIN)
 
 SELECT USERNAME = @TENUSER, 
  HOTEN = (SELECT HO+ ' '+ TEN FROM GIANGVIEN  WHERE MAGV = @TENUSER ),
   TENNHOM= NAME
   FROM sys.sysusers 
   WHERE UID = (SELECT GROUPUID 
                 FROM SYS.SYSMEMBERS 
                   WHERE MEMBERUID= (SELECT UID FROM sys.sysusers 
                                      WHERE NAME=@TENUSER))

GO
/****** Object:  StoredProcedure [dbo].[sp_DsDongHocPhi_Report]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_DsDongHocPhi_Report]
@MALOP char(10),
@NIENKHOA nvarchar(50),
@HOCKY int
AS
BEGIN
	SELECT HO+' '+TEN AS HOTEN, HOCPHI, SOTIENDADONG 
	FROM SINHVIEN LEFT JOIN  HOCPHI ON SINHVIEN.MASV=HOCPHI.MASV  
	WHERE NIENKHOA=@NIENKHOA  AND HOCKY=@HOCKY AND MALOP=@MALOP  AND SINHVIEN.NGHIHOC='false'
	ORDER BY TEN
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfoHpSv]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetInfoHpSv]
@MASV char(12)
AS
BEGIN
	 IF ((SELECT NGHIHOC FROM SINHVIEN WHERE SINHVIEN.MASV=@MASV) = '1')
		BEGIN
			RETURN 1;
		END
	ELSE
		SELECT NIENKHOA,HOCKY,HOCPHI,SOTIENDADONG FROM HOCPHI WHERE MASV=@MASV
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfoSV]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetInfoSV]
@MASV char(12)
AS
BEGIN
	IF EXISTS (SELECT HO+' '+TEN AS HOTEN,MALOP FROM SINHVIEN WHERE MASV=@MASV AND SINHVIEN.NGHIHOC='false')
		BEGIN
			SELECT HO+' '+TEN AS HOTEN,MALOP FROM SINHVIEN WHERE MASV=@MASV AND SINHVIEN.NGHIHOC='false'
		END
	ELSE
		RETURN 1;
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfoSV_Report]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetInfoSV_Report]
@MALOP char(8)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MALOP=@MALOP)
		BEGIN
			SELECT HO, TEN, PHAI, NGAYSINH, NOISINH, DIACHI FROM SINHVIEN WHERE MALOP=@MALOP AND SINHVIEN.NGHIHOC='false'
		END
	ELSE
		RETURN 1;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfoSV_Report_DSTHM]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetInfoSV_Report_DSTHM]
@MALOP char(8)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MALOP=@MALOP)
		BEGIN
			SELECT MASV, HO+' '+TEN AS HOTEN FROM SINHVIEN WHERE MALOP=@MALOP AND SINHVIEN.NGHIHOC='false'
		END
	ELSE
		RETURN 1;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetInfoSV_Report_PDSV]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetInfoSV_Report_PDSV]
@MASV char(12)
AS
BEGIN
		IF EXISTS (SELECT 1 FROM SINHVIEN WHERE MASV=@MASV)
		BEGIN
			SELECT HO+' '+TEN AS HOTEN,SINHVIEN.MALOP,TENLOP 
			FROM SINHVIEN,LOP 
			WHERE MASV=@MASV AND SINHVIEN.MALOP=LOP.MALOP AND SINHVIEN.NGHIHOC='false'
		END
	ELSE
		RETURN 1;
END 
GO
/****** Object:  StoredProcedure [dbo].[sp_GetMaxValueDiem_Report]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetMaxValueDiem_Report]
@MASV char(12)
AS
BEGIN
	if ((SELECT NGHIHOC FROM SINHVIEN WHERE SINHVIEN.MASV=@MASV) = '1')
	BEGIN
		RETURN 1;
	END 
	ELSE
	BEGIN
		SELECT TENMH,MASV,DIEM.MAMH,MAX(DIEM)AS DIEM 
		FROM MONHOC,DIEM
		WHERE DIEM.MAMH= MONHOC.MAMH AND MASV = @MASV  
		GROUP BY DIEM.MAMH ,MASV,TENMH
	END
	
 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetValueDiem]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetValueDiem]
	@MALOP char(8),
	@MAMH char(6),
	@LAN  smallint
AS
BEGIN
 IF EXISTS (SELECT * FROM DBO.SINHVIEN where MALOP=@MALOP)
		 BEGIN
			IF(@LAN=2)
				BEGIN
						IF EXISTS(SELECT MASV,MAMH,LAN,DIEM FROM DIEM WHERE MASV IN (SELECT MASV FROM SINHVIEN WHERE MALOP=@MALOP) AND LAN=2 AND DIEM.MAMH=@MAMH)
					 BEGIN
							SELECT DIEM.MASV,HO + ' ' +TEN AS HOTEN,DIEM FROM DIEM,SINHVIEN
							WHERE DIEM.MASV=SINHVIEN.MASV AND LAN=@LAN AND DIEM.MAMH=@MAMH AND SINHVIEN.NGHIHOC='false' AND MALOP=@MALOP
							ORDER BY DIEM.MASV
					 END
			ELSE
						IF NOT EXISTS(SELECT MASV,MAMH,LAN,DIEM FROM DIEM WHERE MASV IN (SELECT MASV FROM SINHVIEN WHERE MALOP=@MALOP) AND LAN=1 AND DIEM.MAMH=@MAMH)
					 BEGIN
							RETURN 2;
					 END
			ELSE
					 BEGIN
							SELECT MASV,HO + ' ' +TEN AS HOTEN,'' AS DIEM  FROM  SINHVIEN WHERE MALOP=@MALOP AND SINHVIEN.NGHIHOC='false'
					 END
				END	
			IF(@LAN=1)
				BEGIN
					IF EXISTS(SELECT MASV,MAMH,LAN,DIEM FROM DIEM WHERE MASV IN (SELECT MASV FROM SINHVIEN WHERE MALOP=@MALOP) AND LAN=1 AND DIEM.MAMH=@MAMH)	
						BEGIN
							SELECT DIEM.MASV,HO + ' ' +TEN AS HOTEN,DIEM FROM DIEM,SINHVIEN
							WHERE DIEM.MASV=SINHVIEN.MASV AND LAN=@LAN AND DIEM.MAMH=@MAMH AND SINHVIEN.NGHIHOC='false' AND MALOP=@MALOP
							ORDER BY DIEM.MASV
						END
					ELSE
						BEGIN
							SELECT MASV,HO + ' ' +TEN AS HOTEN,'' AS DIEM  FROM  SINHVIEN WHERE MALOP=@MALOP AND SINHVIEN.NGHIHOC='false'
				END		END
		 END
	 ELSE
		BEGIN
			RETURN 1;
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetValueDiem_Report]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetValueDiem_Report]
@MALOP char(8),
@MAMH char(6),
@LAN  int
AS
BEGIN

	SELECT D.MASV,DIEM,HO+' '+TEN AS HOTEN 
	FROM (SELECT MASV,DIEM FROM DIEM 
	WHERE MASV IN (SELECT MASV FROM SINHVIEN WHERE MALOP=@MALOP) AND LAN=@LAN AND DIEM.MAMH=@MAMH) D, SINHVIEN SV
	WHERE D.MASV=SV.MASV AND SV.NGHIHOC='false'
	ORDER BY MASV
		  
END

GO
/****** Object:  StoredProcedure [dbo].[sp_GetValueTableDiem]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_GetValueTableDiem]
@MALOP char(8),
@MAMH char(6),
@LAN  smallint
AS
BEGIN
	IF EXISTS(SELECT 1 FROM DIEM,SINHVIEN WHERE DIEM.MASV=SINHVIEN.MASV AND LAN=@LAN AND DIEM.MAMH=@MAMH AND SINHVIEN.NGHIHOC='false' AND MALOP=@MALOP)
	   BEGIN
		   SELECT DIEM.MASV+'- '+HO+' '+TEN ,MAMH,LAN,DIEM FROM DIEM,SINHVIEN
		   WHERE DIEM.MASV=SINHVIEN.MASV AND LAN=@LAN AND DIEM.MAMH=@MAMH AND SINHVIEN.NGHIHOC='false' AND MALOP=@MALOP
		   ORDER BY DIEM.MASV
	   END
   ELSE
	 RETURN 1
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_InsertSv]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_InsertSv]
@MASV char(12),
@HO nvarchar(40),
@TEN nvarchar(10),
@MALOP char(8),
@PHAI bit,
@NGAYSINH datetime,
@NOISINH nvarchar(40),
@DIACHI nvarchar(80),
@GHICHU ntext,
@NGHIHOC bit
AS
BEGIN
	INSERT INTO DBO.SINHVIEN(MASV,HO,TEN,MALOP,PHAI,NGAYSINH,NOISINH,DIACHI,GHICHU,NGHIHOC)
			VALUES (@MASV, @HO, @TEN, @MALOP,@PHAI,@NGAYSINH,@NOISINH,@DIACHI,@GHICHU,@NGHIHOC)
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertValueDiem]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_InsertValueDiem]
@MASV char(12),
@MAMH char(6),
@LAN  smallint,
@DIEM float
AS
BEGIN
			IF EXISTS (SELECT 1 FROM DIEM WHERE MASV=@MASV AND MAMH=@MAMH AND LAN=@LAN)
				BEGIN
					UPDATE DIEM
					SET DIEM = @DIEM 
					WHERE MASV= @MASV AND LAN=@LAN AND MAMH=@MAMH
				END
			ELSE
				BEGIN
					INSERT INTO DBO.DIEM (MASV, MAMH, LAN, DIEM)
					VALUES (@MASV, @MAMH, @LAN, @DIEM)
				END	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_InsertValueHP]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_InsertValueHP]
@MASV char(12),
@NIENKHOA nvarchar(50),
@HOCKY int,
@HOCPHI int,
@SOTIENDADONG int
AS
BEGIN		
	IF EXISTS (SELECT 1 FROM HOCPHI WHERE MASV=@MASV AND NIENKHOA=@NIENKHOA AND HOCKY= @HOCKY)
			BEGIN
				UPDATE HOCPHI
				SET HOCPHI=@HOCPHI , SOTIENDADONG=@SOTIENDADONG
				WHERE MASV=@MASV AND NIENKHOA=@NIENKHOA AND HOCKY= @HOCKY
			END
	ELSE
		BEGIN
			INSERT INTO HOCPHI(MASV, NIENKHOA, HOCKY,HOCPHI,SOTIENDADONG)
			SELECT MASV,@NIENKHOA,@HOCKY,0,0 FROM SINHVIEN WHERE NGHIHOC='false' AND MALOP in (SELECT MALOP FROM SINHVIEN WHERE MASV=@MASV )
			UPDATE HOCPHI SET HOCPHI=@HOCPHI, SOTIENDADONG=@SOTIENDADONG WHERE MASV=@MASV;
		END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraMaGVDaTaoLogin]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_KiemTraMaGVDaTaoLogin]
	@LGNAME VARCHAR(50),
	@USERNAME VARCHAR(50)
AS
BEGIN	
	DECLARE @RET INT

  EXEC @RET= SP_GRANTDBACCESS @LGNAME, @USERNAME
  IF (@RET =1)  -- USER  NAME BI TRUNG
	BEGIN
		EXEC SP_DROPLOGIN @LGNAME              
       RETURN 2
	END
  ELSE
	 BEGIN
		SELECT MAGV,TEN FROM DBO.GIANGVIEN WHERE MAGV=@USERNAME
	 END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraMaLopTonTai]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_KiemTraMaLopTonTai]
@MALOP char(13)
AS
BEGIN
	 -- KIEM TRA TRONG TABLE SINH VIEN CUA SERVER HIEN TAI
	 IF EXISTS(SELECT 1 FROM DBO.LOP WHERE DBO.LOP.MALOP = @MALOP)
	 BEGIN
		SELECT  1 ; -- MA LOp TON TAI 
	 END
	 -- KIEM TRA TRONG TABLE SINH VIEN CUA PHAN MANH CON LAI
	 IF EXISTS(SELECT 1 FROM LINK.QL_SV.DBO.LOP LOP WHERE LOP.MALOP = @MALOP)
	 BEGIN
		SELECT  1 ; -- MA LOP TON TAI
	END

	SELECT  0 ;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraMaMonHocTonTai]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_KiemTraMaMonHocTonTai]
@MAMH char(13)
AS
BEGIN
	 -- KIEM TRA TRONG TABLE SINH VIEN CUA SERVER HIEN TAI
	 IF EXISTS(SELECT 1 FROM DBO.MONHOC WHERE DBO.MONHOC.MAMH = @MAMH)
	 BEGIN
		SELECT  1 ; -- MA MON HOC TON TAI 
	 END
	 -- KIEM TRA TRONG TABLE SINH VIEN CUA PHAN MANH CON LAI
	 IF EXISTS(SELECT 1 FROM LINK.QL_SV.DBO.MONHOC MONHOC WHERE MONHOC.MAMH = @MAMH)
	 BEGIN
		SELECT  1 ; -- MA MON HOC TON TAI
	END

	SELECT  0 ;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_KiemTraMaSinhVienTonTai]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_KiemTraMaSinhVienTonTai]
@MASV char(13)
AS
BEGIN
	 -- KIEM TRA TRONG TABLE SINH VIEN CUA SERVER HIEN TAI
	 IF EXISTS(SELECT 1 FROM DBO.SINHVIEN WHERE DBO.SINHVIEN.MASV = @MASV)
	 BEGIN
		SELECT  1 ; -- MA SINNH VIEN TON TAI 
	 END
	 -- KIEM TRA TRONG TABLE SINH VIEN CUA PHAN MANH CON LAI
	 IF EXISTS(SELECT 1 FROM LINK.QL_SV.DBO.SINHVIEN SV WHERE SV.MASV = @MASV)
	 BEGIN
		SELECT  1 ; -- MA SINH VIEN TON TAI
	END

	SELECT  0 ;
END
GO
/****** Object:  StoredProcedure [dbo].[sp_LocMaGVDaTaoLogin]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_LocMaGVDaTaoLogin]
AS
BEGIN	
DECLARE @TENUSER NVARCHAR(50)
SELECT @TENUSER=MAGV FROM GIANGVIEN 

if NOT EXISTS (SELECT sp.name AS login_name
FROM sys.server_principals sp
JOIN sys.database_principals dp ON (sp.sid = dp.sid)
WHERE dp.name = @TENUSER)
BEGIN
	SELECT MAGV=@TENUSER FROM GIANGVIEN 
END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_TaoTaiKhoan]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_TaoTaiKhoan]
	@LGNAME VARCHAR(50),
	@PASS VARCHAR(50),
	@USERNAME VARCHAR(50),
	@ROLE VARCHAR(50)
AS
BEGIN
  DECLARE @RET INT
  EXEC @RET= SP_ADDLOGIN @LGNAME, @PASS,'QL_SV'                     

  IF (@RET =1)  -- LOGIN NAME BI TRUNG
     RETURN 1

  EXEC @RET= SP_GRANTDBACCESS @LGNAME, @USERNAME
  IF (@RET =1)  -- USER  NAME BI TRUNG
  BEGIN              
       EXEC SP_DROPLOGIN @LGNAME
       RETURN 2
  END
  EXEC sp_addrolemember @ROLE, @USERNAME

  IF @ROLE= 'PGV' 
	BEGIN
		EXEC sp_addsrvrolemember @LGNAME, 'sysadmin'
		EXEC sp_addsrvrolemember @LGNAME, 'SecurityAdmin'
		EXEC sp_addsrvrolemember @LGNAME, 'ProcessAdmin'
	END

  IF @ROLE= 'KHOA'
	BEGIN 
		EXEC sp_addsrvrolemember @LGNAME, 'sysadmin'
		EXEC sp_addsrvrolemember @LGNAME, 'SecurityAdmin'
		EXEC sp_addsrvrolemember @LGNAME, 'ProcessAdmin'
	END
  IF @ROLE= 'USER'
	BEGIN  
		EXEC sp_addsrvrolemember @LGNAME, 'ProcessAdmin'
	END

  IF @ROLE= 'PKeToan'
	BEGIN  
		EXEC sp_addsrvrolemember @LGNAME, 'sysadmin'
		EXEC sp_addsrvrolemember @LGNAME, 'SecurityAdmin'
		EXEC sp_addsrvrolemember @LGNAME, 'ProcessAdmin'
	END
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateValueTableDiem]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_UpdateValueTableDiem]
@MASV char(12),
@LAN  smallint,
@MAMH char(6),
@DIEM float
AS
BEGIN
		UPDATE DIEM
		SET DIEM = @DIEM 
		WHERE DBO.DIEM.MASV= @MASV AND DBO.DIEM.LAN=@LAN AND DBO.DIEM.MAMH=@MAMH
END

GO
/****** Object:  Table [dbo].[DIEM]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DIEM](
	[MASV] [char](12) NOT NULL,
	[MAMH] [char](6) NOT NULL,
	[LAN] [smallint] NOT NULL,
	[DIEM] [float] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_DIEM] PRIMARY KEY CLUSTERED 
(
	[MASV] ASC,
	[MAMH] ASC,
	[LAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GIANGVIEN]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GIANGVIEN](
	[MAGV] [nchar](10) NOT NULL,
	[HO] [nvarchar](50) NOT NULL,
	[TEN] [nvarchar](10) NOT NULL,
	[MAKH] [char](4) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_GIANGVIEN] PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HOCPHI]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HOCPHI](
	[MASV] [char](12) NOT NULL,
	[NIENKHOA] [nvarchar](50) NOT NULL,
	[HOCKY] [int] NOT NULL,
	[HOCPHI] [int] NOT NULL,
	[SOTIENDADONG] [int] NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_HOCPHI] PRIMARY KEY CLUSTERED 
(
	[MASV] ASC,
	[NIENKHOA] ASC,
	[HOCKY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KHOA]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHOA](
	[MAKH] [char](4) NOT NULL,
	[TENKH] [nvarchar](50) NOT NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_KHOA] PRIMARY KEY CLUSTERED 
(
	[MAKH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LOP]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LOP](
	[MALOP] [char](8) NOT NULL,
	[TENLOP] [nvarchar](200) NULL,
	[MAKH] [char](4) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_LOP] PRIMARY KEY CLUSTERED 
(
	[MALOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MONHOC]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MONHOC](
	[MAMH] [char](6) NOT NULL,
	[TENMH] [nvarchar](40) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_MONHOC] PRIMARY KEY CLUSTERED 
(
	[MAMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SINHVIEN]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SINHVIEN](
	[MASV] [char](12) NOT NULL,
	[HO] [nvarchar](40) NULL,
	[TEN] [nvarchar](10) NULL,
	[MALOP] [char](8) NOT NULL,
	[PHAI] [bit] NULL,
	[NGAYSINH] [datetime] NULL,
	[NOISINH] [nvarchar](40) NULL,
	[DIACHI] [nvarchar](80) NULL,
	[GHICHU] [ntext] NULL,
	[NGHIHOC] [bit] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
 CONSTRAINT [PK_SINHVIEN] PRIMARY KEY CLUSTERED 
(
	[MASV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[V_DS_PHANMANH]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_DS_PHANMANH]
AS
SELECT        PUBS.description AS TENCN, SUBS.subscriber_server AS TENSERVER
FROM            dbo.sysmergepublications AS PUBS INNER JOIN
                         dbo.sysmergesubscriptions AS SUBS ON PUBS.pubid = SUBS.pubid AND PUBS.publisher <> SUBS.subscriber_server

GO
/****** Object:  View [dbo].[v_SISO]    Script Date: 11/28/2018 3:16:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[v_SISO]
AS
SELECT L.MALOP , L.TENLOP, COUNT(S.MASV ) AS SISO
FROM LOP L LEFT JOIN 
  (SELECT MASV, MALOP FROM SINHVIEN WHERE NGHIHOC='FALSE') S
     ON L.MALOP=S.MALOP 
GROUP BY L.MALOP, L.TENLOP

GO
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'08VTA101    ', N'CSDL  ', 1, 2, N'1d4d91a4-50db-e811-87f8-b88687a90a87')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'08VTA101    ', N'CTDL  ', 1, 3, N'78f4771e-c8d5-e811-87f7-b88687a90a87')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'08VTA101    ', N'CTDL  ', 2, 4, N'a1dea14b-fdd9-e811-87f8-b88687a90a87')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'08VTA102    ', N'CSDL  ', 1, 2, N'1e4d91a4-50db-e811-87f8-b88687a90a87')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'08VTA102    ', N'CTDL  ', 1, 2, N'79f4771e-c8d5-e811-87f7-b88687a90a87')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'08VTA102    ', N'CTDL  ', 2, 0, N'a2dea14b-fdd9-e811-87f8-b88687a90a87')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N10CCCN001  ', N'CSDL  ', 1, 6, N'62e8426c-48f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N10CCCN001  ', N'CTDL  ', 1, 4, N'e2389441-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N10CCCN001  ', N'CTDL  ', 2, 8, N'5ed24551-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N10CCCN002  ', N'CSDL  ', 1, 7, N'63e8426c-48f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N10CCCN002  ', N'CTDL  ', 1, 5, N'e3389441-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N10CCCN002  ', N'CTDL  ', 2, 9, N'5fd24551-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N15DCCN084  ', N'VB    ', 1, 3, N'2dbf8e66-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N15DCCN141  ', N'VB    ', 1, 4, N'2ebf8e66-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[DIEM] ([MASV], [MAMH], [LAN], [DIEM], [rowguid]) VALUES (N'N15DCCN187  ', N'VB    ', 1, 5, N'2fbf8e66-47f1-e811-87fd-1c1b0d84c1dd')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV01      ', N'NGUYEN HONG', N'SON       ', N'CNTT', N'95e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV02      ', N'TRUONG DINH', N'HUY       ', N'CNTT', N'96e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV03      ', N'NGUYEN XUAN', N'KHANH', N'VT  ', N'97e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV04      ', N'TRAN DINH', N'THUAN', N'VT  ', N'98e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV05      ', N'NGUYEN VAN', N'A', N'VT  ', N'a1dff8a4-2ad7-e811-87f7-b88687a90a87')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV06      ', N'NGUYEN VAN', N'B', N'CNTT', N'd7eb77b3-2ad7-e811-87f7-b88687a90a87')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV07      ', N'NGUYEN VAN', N'C', N'CNTT', N'1d510df8-2cd7-e811-87f7-b88687a90a87')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV08      ', N'NGUYEN VAN ', N'D', N'CNTT', N'57b41837-0fe8-e811-87f8-b88687a90a87')
INSERT [dbo].[GIANGVIEN] ([MAGV], [HO], [TEN], [MAKH], [rowguid]) VALUES (N'GV09      ', N'NGUYEN VAN', N'E', N'VT  ', N'80d6c948-10e8-e811-87f8-b88687a90a87')
INSERT [dbo].[HOCPHI] ([MASV], [NIENKHOA], [HOCKY], [HOCPHI], [SOTIENDADONG], [rowguid]) VALUES (N'N10CCCN001  ', N'2010-2014', 1, 2000000, 2000000, N'663c4eff-7ef0-e811-87fb-1c1b0d84c1dd')
INSERT [dbo].[HOCPHI] ([MASV], [NIENKHOA], [HOCKY], [HOCPHI], [SOTIENDADONG], [rowguid]) VALUES (N'N10CCCN001  ', N'2010-2014', 2, 2500000, 2500000, N'de6f0fad-7ff0-e811-87fb-1c1b0d84c1dd')
INSERT [dbo].[HOCPHI] ([MASV], [NIENKHOA], [HOCKY], [HOCPHI], [SOTIENDADONG], [rowguid]) VALUES (N'N10CCCN001  ', N'2010-2014', 3, 2000000, 2000000, N'97f0c2f4-85f0-e811-87fb-1c1b0d84c1dd')
INSERT [dbo].[HOCPHI] ([MASV], [NIENKHOA], [HOCKY], [HOCPHI], [SOTIENDADONG], [rowguid]) VALUES (N'N10CCCN002  ', N'2010-2014', 1, 2000000, 2000000, N'673c4eff-7ef0-e811-87fb-1c1b0d84c1dd')
INSERT [dbo].[HOCPHI] ([MASV], [NIENKHOA], [HOCKY], [HOCPHI], [SOTIENDADONG], [rowguid]) VALUES (N'N10CCCN002  ', N'2010-2014', 2, 1500000, 1500000, N'df6f0fad-7ff0-e811-87fb-1c1b0d84c1dd')
INSERT [dbo].[HOCPHI] ([MASV], [NIENKHOA], [HOCKY], [HOCPHI], [SOTIENDADONG], [rowguid]) VALUES (N'N10CCCN002  ', N'2010-2014', 3, 0, 0, N'98f0c2f4-85f0-e811-87fb-1c1b0d84c1dd')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [rowguid]) VALUES (N'CNTT', N'Công nghệ thông tin', N'8be0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[KHOA] ([MAKH], [TENKH], [rowguid]) VALUES (N'VT  ', N'Viễn thông', N'8ce0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH], [rowguid]) VALUES (N'C10THA1 ', N'Cao đẳng chính qui ngành CNTT', N'CNTT', N'9be0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH], [rowguid]) VALUES (N'D08VTA1 ', N'Đại học chính qui 1  Viễn thông Khóa 2008', N'VT  ', N'9ce0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH], [rowguid]) VALUES (N'D09VTA1 ', N'Đại học chính qui 1  Viễn thông Khóa 2009', N'VT  ', N'9de0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH], [rowguid]) VALUES (N'D15CQCN1', N'Đại học chính qui 1  ngành Hệ thống thông tin Khóa 2015', N'CNTT', N'b0fcc6bf-c2ce-e811-87f5-b88687a90a87')
INSERT [dbo].[LOP] ([MALOP], [TENLOP], [MAKH], [rowguid]) VALUES (N'D16CQCN1', N'Đại học chính qui 1  ngành Công nghệ thông tin Khóa 2016', N'CNTT', N'9ae0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'CSDL  ', N'Cơ sở dữ liệu', N'8ee0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'CSDLPT', N'Cơ sở dữ liệu phân tán', N'8fe0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'CTDL  ', N'Cấu trúc dữ liệu', N'8de0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'LTCB  ', N'Lập trình căn bản', N'91e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'THCS1 ', N'Tin học cơ sở 1 ', N'92e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'THDC  ', N'Tin học đại cương', N'93e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'TRR1  ', N'Toán rời rạc 1', N'94e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[MONHOC] ([MAMH], [TENMH], [rowguid]) VALUES (N'VB    ', N'Lập trình Visual Basic nâng cao', N'90e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'08VTA101    ', N'Nguyễn Thanh', N'Hằng', N'D08VTA1 ', 1, CAST(0x00006C5500000000 AS DateTime), N'Đà Lạt', N'11 Nguyễn Biểu', N'', 0, N'a0e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'08VTA102    ', N'Võ Văn', N'Phát', N'D08VTA1 ', 1, CAST(0x00006CEB00000000 AS DateTime), N'Đồng Nai', N'22 Bá Thành', N' ', 0, N'a4e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'09VTA101    ', N'Phạm Xuân', N'Hiếu', N'D09VTA1 ', 1, CAST(0x00008C8900000000 AS DateTime), N'Ninh Thuận', N'3A Xuân Nghị', N'', 0, N'5a36707e-7ce1-e811-87f8-b88687a90a87')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N10CCCN001  ', N'Trần Nguyễn', N'Minh', N'C10THA1 ', 1, CAST(0x0000883B00000000 AS DateTime), N'Cà Mau', N'22 Tản Đà', N' ', 0, N'a3e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N10CCCN002  ', N'Nguyễn Hoàng', N'An', N'C10THA1 ', 1, CAST(0x0000882600000000 AS DateTime), N'Phú Yên', N'12 Cánh Đồng', NULL, 0, N'9ee0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N10CCCN003  ', N'Lê Thị', N'Hà', N'C10THA1 ', 0, CAST(0x000087BB00000000 AS DateTime), N'Đà Lạt', N'61 Phù Đổng', N'', 1, N'9fe0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N15DCCN084  ', N'Trần Cảnh', N'Dinh', N'D15CQCN1', 1, CAST(0x000087C600000000 AS DateTime), N'Quảng Trị', N'97 Man Thiện', N'G..ay', 0, N'685d4396-16e8-e811-87f8-b88687a90a87')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N15DCCN136  ', N'Võ Tùng', N'Nghĩa', N'D15CQCN1', 1, CAST(0x00008B4700000000 AS DateTime), N'Đồng Nai', N'161 TCD', N':)', 1, N'd231c92e-6ade-e811-87f8-b88687a90a87')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N15DCCN141  ', N'Hồ Quang', N'Việt', N'D15CQCN1', 1, CAST(0x000088F700000000 AS DateTime), N'Di Linh', N'123 Bảng Đôn', N'G..ay', 0, N'3d740273-17e8-e811-87f8-b88687a90a87')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N15DCCN187  ', N'Phạm Duy', N'Thương', N'D15CQCN1', 1, CAST(0x00008AA100000000 AS DateTime), N'DakLak', N'74 Bảng Địa', N'Mac..Bút', 0, N'dadb9353-18e8-e811-87f8-b88687a90a87')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N16DCCN001  ', N'Lê Thị', N'Văn', N'D16CQCN1', 0, CAST(0x00006D0B00000000 AS DateTime), N'Quảng Ngãi', N'Ngô Quyền', N' ', 0, N'a5e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N16DCCN002  ', N'Trần Thi', N'Hoa', N'D16CQCN1', 0, CAST(0x00006D2A00000000 AS DateTime), N'Sài Gòn', N'22 Lý Thái Tổ', N' ', 0, N'a1e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N16DCCN003  ', N'Nguyễn Thị Yến', N'Lan', N'D16CQCN1', 0, CAST(0x00006D4A00000000 AS DateTime), N'Khánh Hòa', N'33 Ngọc Tuấn', NULL, 0, N'a2e0a916-f3c5-e811-87f4-1c1b0d84c1dd')
INSERT [dbo].[SINHVIEN] ([MASV], [HO], [TEN], [MALOP], [PHAI], [NGAYSINH], [NOISINH], [DIACHI], [GHICHU], [NGHIHOC], [rowguid]) VALUES (N'N16DCCN004  ', N'Nguyễn Hoàng', N'Dũng', N'D16CQCN1', 1, CAST(0x000083FF00000000 AS DateTime), N'Hà Nội', N'123 Núi Đá', NULL, NULL, N'5c6b24b7-dce1-e811-87f8-b88687a90a87')
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_TENLOP]    Script Date: 11/28/2018 3:16:00 PM ******/
ALTER TABLE [dbo].[LOP] ADD  CONSTRAINT [UK_TENLOP] UNIQUE NONCLUSTERED 
(
	[TENLOP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_MONHOC]    Script Date: 11/28/2018 3:16:00 PM ******/
ALTER TABLE [dbo].[MONHOC] ADD  CONSTRAINT [IX_MONHOC] UNIQUE NONCLUSTERED 
(
	[TENMH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DIEM] ADD  CONSTRAINT [MSmerge_df_rowguid_09D4F1669ED147A9814899601555FBC0]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[GIANGVIEN] ADD  CONSTRAINT [MSmerge_df_rowguid_E7D9E1531F5D456EA0FDCD78353A73B4]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[HOCPHI] ADD  CONSTRAINT [DF_HOCPHI_HOCKY]  DEFAULT ((1)) FOR [HOCKY]
GO
ALTER TABLE [dbo].[HOCPHI] ADD  CONSTRAINT [DF_HOCPHI_HOCPHI]  DEFAULT ((6000000)) FOR [HOCPHI]
GO
ALTER TABLE [dbo].[HOCPHI] ADD  CONSTRAINT [DF_HOCPHI_SOTIENDADONG]  DEFAULT ((0)) FOR [SOTIENDADONG]
GO
ALTER TABLE [dbo].[HOCPHI] ADD  CONSTRAINT [MSmerge_df_rowguid_9F2262A9E2514F8B8CA7B63E66F1620C]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[KHOA] ADD  CONSTRAINT [MSmerge_df_rowguid_19196A25F5B14DAF93E284995C1412F8]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[LOP] ADD  CONSTRAINT [MSmerge_df_rowguid_47A1CF90B7F34CBC904E0A46DA0B3C76]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[MONHOC] ADD  CONSTRAINT [MSmerge_df_rowguid_028919E66F354E0C8464E8D97404EC02]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[SINHVIEN] ADD  CONSTRAINT [MSmerge_df_rowguid_22BDABB8632648EB9CC2C30E7481E93A]  DEFAULT (newsequentialid()) FOR [rowguid]
GO
ALTER TABLE [dbo].[DIEM]  WITH CHECK ADD  CONSTRAINT [FK_DIEM_MONHOC1] FOREIGN KEY([MAMH])
REFERENCES [dbo].[MONHOC] ([MAMH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DIEM] CHECK CONSTRAINT [FK_DIEM_MONHOC1]
GO
ALTER TABLE [dbo].[DIEM]  WITH NOCHECK ADD  CONSTRAINT [FK_DIEM_SINHVIEN] FOREIGN KEY([MASV])
REFERENCES [dbo].[SINHVIEN] ([MASV])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[DIEM] CHECK CONSTRAINT [FK_DIEM_SINHVIEN]
GO
ALTER TABLE [dbo].[GIANGVIEN]  WITH CHECK ADD  CONSTRAINT [FK_GIANGVIEN_KHOA] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHOA] ([MAKH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[GIANGVIEN] CHECK CONSTRAINT [FK_GIANGVIEN_KHOA]
GO
ALTER TABLE [dbo].[HOCPHI]  WITH CHECK ADD  CONSTRAINT [FK_HOCPHI_SINHVIEN] FOREIGN KEY([MASV])
REFERENCES [dbo].[SINHVIEN] ([MASV])
GO
ALTER TABLE [dbo].[HOCPHI] CHECK CONSTRAINT [FK_HOCPHI_SINHVIEN]
GO
ALTER TABLE [dbo].[LOP]  WITH CHECK ADD  CONSTRAINT [FK_LOP_KHOA1] FOREIGN KEY([MAKH])
REFERENCES [dbo].[KHOA] ([MAKH])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[LOP] CHECK CONSTRAINT [FK_LOP_KHOA1]
GO
ALTER TABLE [dbo].[SINHVIEN]  WITH CHECK ADD  CONSTRAINT [FK_SINHVIEN_LOP] FOREIGN KEY([MALOP])
REFERENCES [dbo].[LOP] ([MALOP])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SINHVIEN] CHECK CONSTRAINT [FK_SINHVIEN_LOP]
GO
ALTER TABLE [dbo].[DIEM]  WITH NOCHECK ADD  CONSTRAINT [CK_DIEM_DIEM] CHECK  (([DIEM]>=(0) AND [DIEM]<=(10)))
GO
ALTER TABLE [dbo].[DIEM] CHECK CONSTRAINT [CK_DIEM_DIEM]
GO
ALTER TABLE [dbo].[DIEM]  WITH NOCHECK ADD  CONSTRAINT [CK_DIEM_LAN] CHECK  (([LAN]=(1) OR [LAN]=(2)))
GO
ALTER TABLE [dbo].[DIEM] CHECK CONSTRAINT [CK_DIEM_LAN]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "PUBS"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 321
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SUBS"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_DS_PHANMANH'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'V_DS_PHANMANH'
GO
