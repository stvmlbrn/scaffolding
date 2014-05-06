/* CREATE THE FAILEDLOGINS TABLE */

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[failedLogins](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](50) NOT NULL,
	[ipAddress] [varchar](50) NOT NULL,
	[reason] [varchar](50) NOT NULL,
	[attemptDate] [datetime] NOT NULL,
 CONSTRAINT [PK_failedLogins] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[failedLogins] ADD  CONSTRAINT [DF_failedLogins_attemptDate]  DEFAULT (getdate()) FOR [attemptDate]
GO


/*	CREATE THE USERLOG TABLE */
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[userLog](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[userID] [varchar](50) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[loginDate] [datetime] NOT NULL,
	[ipAddress] [varchar](50) NOT NULL,
	[user_agent] [varchar](max) NOT NULL,
 CONSTRAINT [PK_userLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[userLog] ADD  CONSTRAINT [DF_userLog_loginDate]  DEFAULT (getdate()) FOR [loginDate]
GO


