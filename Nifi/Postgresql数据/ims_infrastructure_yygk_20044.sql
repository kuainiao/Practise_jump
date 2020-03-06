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

Date: 2018-07-25 16:22:43
*/


-- ----------------------------
-- Table structure for ims_infrastructure_yygk_20044
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_yygk_20044";
CREATE TABLE "xxyg"."ims_infrastructure_yygk_20044" (
"kpiid" varchar(50) COLLATE "default",
"corpcode" varchar(19) COLLATE "default",
"corpname" varchar(100) COLLATE "default",
"time" timestamp(6),
"value" varchar(10) COLLATE "default",
"bi_rowid" varchar(64) COLLATE "default",
"bi_sfdm" varchar(20) COLLATE "default",
"bi_jzsj" timestamp(6),
"bi_jlsj" timestamp(6)
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."kpiid" IS '指标ID';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."corpcode" IS '单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."corpname" IS '单位名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."time" IS '时间';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."value" IS '虚拟机数量';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."bi_rowid" IS '源ORACLE表的ROWID';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."bi_sfdm" IS '省份代码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."bi_jzsj" IS '加载时间';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_20044"."bi_jlsj" IS '记录时间';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
