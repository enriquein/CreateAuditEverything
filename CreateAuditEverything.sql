/*** Create audit tables for |ObjectName| and its triggers ***/

declare @author varchar(200)
declare @date varchar(12)
declare @pk varchar (255)
set @author = ''
set @date = ''
select @pk = coalesce(@pk + ' and', ' on') + ' i.' + c.COLUMN_NAME + ' = d.' + c.COLUMN_NAME
from INFORMATION_SCHEMA.TABLE_CONSTRAINTS pk ,
INFORMATION_SCHEMA.KEY_COLUMN_USAGE c
where pk.TABLE_NAME = '|ObjectName|'
and CONSTRAINT_TYPE = 'PRIMARY KEY'
and c.TABLE_NAME = pk.TABLE_NAME
and c.CONSTRAINT_NAME = pk.CONSTRAINT_NAME

select 'RAISERROR (N''Checkpoint: Start creating |ObjectName|_audit and its triggers.'', 10, 1) WITH NOWAIT;' union all
select 'GO' union all
select 'SET ANSI_NULLS ON' union all
select 'GO' union all
select 'SET QUOTED_IDENTIFIER ON' union all
select 'GO' union all
select 'SET ANSI_PADDING ON' union all
select 'GO' union all
select 'CREATE TABLE |ObjectName|_audit(' union all
select '    [Id] [int] IDENTITY(1,1) NOT NULL' union all
select '    , [Action] varchar(16) NOT NULL' union all
select '    , ActionUser varchar(250) DEFAULT SYSTEM_USER' union all
select '    , ActionDate datetime DEFAULT CURRENT_TIMESTAMP ' union all
select 
    '   , ' + COLUMN_NAME + '_before ' + DATA_TYPE + 
        case 
            WHEN CHARACTER_MAXIMUM_LENGTH is NULL THEN ''
            else
            '(' + convert(varchar, CHARACTER_MAXIMUM_LENGTH) + ')'
        end +
    '   , ' + COLUMN_NAME + '_after ' + DATA_TYPE + 
        case 
            WHEN CHARACTER_MAXIMUM_LENGTH is NULL THEN ''
            else
            '(' + convert(varchar, CHARACTER_MAXIMUM_LENGTH) + ')'
        end
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' union all
select '' union all
select 'CONSTRAINT [PK_|ObjectName|_audit] PRIMARY KEY CLUSTERED ' union all
select '(' union all
select '	[Id] ASC' union all
select ')WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]' union all
select ') ON [PRIMARY]' union all
select 'GO' union all
select 'SET ANSI_PADDING OFF' union all
select 'GO' union all
select '' union all
select '-- TRIGGERS' union all
select '' union all
select 'SET ANSI_NULLS ON' union all
select 'GO' union all
select 'SET QUOTED_IDENTIFIER ON' union all
select 'GO' union all
select '-- =============================================' union all
select '-- Author:		' + @author union all
select '-- Create date: ' + @date union all
select '-- Description:	Audit triggers for |ObjectName|' union all
select '-- =============================================' union all
select 'CREATE TRIGGER |SchemaName|.tr_ins_|ObjectName|' union all
select '   ON  |SchemaName|.|ObjectName|' union all
select '   AFTER INSERT' union all
select 'AS ' union all
select 'BEGIN' union all
select '	IF @@ROWCOUNT = 0 ' union all
select '	    return; ' union all
select ' ' union all
select '	SET NOCOUNT ON; ' union all
select ' ' union all	
select 'insert into |ObjectName|_audit ([Action]' union all
select 
    '   , ' + COLUMN_NAME + '_before, ' + COLUMN_NAME + '_after'  
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' 
    union all	    
select ')' union all
select '    select ''INSERT''' union all
select 
    '       , '''', ' + COLUMN_NAME   
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' 
    union all	
select '    from inserted ' union all
select 'END' union all
select 'GO' union all
select '' union all
select 'SET ANSI_NULLS ON' union all
select 'GO' union all
select 'SET QUOTED_IDENTIFIER ON' union all
select 'GO' union all
select '-- =============================================' union all
select '-- Author:		' + @author union all
select '-- Create date: ' + @date union all
select '-- Description:	Audit triggers for |ObjectName|' union all
select '-- =============================================' union all
select 'CREATE TRIGGER |SchemaName|.tr_upd_|ObjectName|' union all
select '   ON  |SchemaName|.|ObjectName|' union all
select '   AFTER UPDATE' union all
select 'AS ' union all
select 'BEGIN' union all
select '	IF @@ROWCOUNT = 0 ' union all
select '	    return; ' union all
select ' ' union all
select '	SET NOCOUNT ON; ' union all
select ' ' union all	
select 'insert into |ObjectName|_audit ([Action]' union all
select 
    '   , ' + COLUMN_NAME + '_before, ' + COLUMN_NAME + '_after'  
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' 
    union all	    
select ')' union all
select '    select ''UPDATE''' union all
select 
    '       , d.' + COLUMN_NAME + ', i.' + COLUMN_NAME   
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' 
    union all	
select '    from inserted i inner join deleted d' + isnull(@pk, ' [!NO PRIMARY KEY FOUND ON TABLE!]') union all
select 'END' union all
select 'GO' union all
select '' union all
select 'SET ANSI_NULLS ON' union all
select 'GO' union all
select 'SET QUOTED_IDENTIFIER ON' union all
select 'GO' union all
select '-- =============================================' union all
select '-- Author:		' + @author union all
select '-- Create date: ' + @date union all
select '-- Description:	Audit triggers for |ObjectName|' union all
select '-- =============================================' union all
select 'CREATE TRIGGER |SchemaName|.tr_del_|ObjectName|' union all
select '   ON  |SchemaName|.|ObjectName|' union all
select '   AFTER DELETE' union all
select 'AS ' union all
select 'BEGIN' union all
select '	IF @@ROWCOUNT = 0 ' union all
select '	    return; ' union all
select ' ' union all
select '	SET NOCOUNT ON; ' union all
select ' ' union all	
select 'insert into |ObjectName|_audit ([Action]' union all
select 
    '   , ' + COLUMN_NAME + '_before, ' + COLUMN_NAME + '_after'  
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' 
    union all	    
select ')' union all
select '    select ''DELETE''' union all
select 
    '       , ' + COLUMN_NAME + ', '''''    
from 
    INFORMATION_SCHEMA.COLUMNS 
where 
    TABLE_CATALOG = '|DatabaseName|' and 
    TABLE_SCHEMA = '|SchemaName|' and 
    TABLE_NAME = '|ObjectName|' 
    union all	
select '    from deleted ' union all
select 'END' union all
select 'GO' union all
select 'RAISERROR (N''Checkpoint: End creating |ObjectName|_audit and its triggers.'', 10, 1) WITH NOWAIT;' union all
select 'GO'  
/***      End      ***/