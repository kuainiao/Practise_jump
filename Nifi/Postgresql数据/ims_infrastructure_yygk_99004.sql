/*
Navicat PGSQL Data Transfer

Source Server         : test
Source Server Version : 90606
Source Host           : 10.115.164.24:5432
Source Database       : ims_db
Source Schema         : xxyg

Target Server Type    : PGSQL
Target Server Version : 90606
File Encoding         : 65001

Date: 2018-07-25 16:23:04
*/


-- ----------------------------
-- Table structure for ims_infrastructure_yygk_99004
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_yygk_99004";
CREATE TABLE "xxyg"."ims_infrastructure_yygk_99004" (
"corpcode" varchar(19) COLLATE "default",
"corpname" varchar(100) COLLATE "default",
"upcorpcode" varchar(19) COLLATE "default",
"bi_rowid" varchar(64) COLLATE "default",
"bi_sfdm" varchar(20) COLLATE "default" NOT NULL,
"bi_jzsj" timestamp(6),
"bi_jlsj" timestamp(6)
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."corpcode" IS '单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."corpname" IS '单位名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."upcorpcode" IS '上级单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."bi_rowid" IS '源ORACLE表的ROWID';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."bi_sfdm" IS '省份代码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."bi_jzsj" IS '加载时间';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99004"."bi_jlsj" IS '记录时间';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
