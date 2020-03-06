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

Date: 2018-07-25 16:12:58
*/


-- ----------------------------
-- Table structure for ims_infrastructure_getequipcomnum
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_getequipcomnum";
CREATE TABLE "xxyg"."ims_infrastructure_getequipcomnum" (
"corpcode" varchar(19) COLLATE "default",
"sumvalue" numeric,
"dictid" varchar(20) COLLATE "default",
"time" timestamp(6)
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_getequipcomnum"."corpcode" IS '单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_getequipcomnum"."sumvalue" IS '总设备数量';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_getequipcomnum"."dictid" IS '设备类别编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_getequipcomnum"."time" IS '时间';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
