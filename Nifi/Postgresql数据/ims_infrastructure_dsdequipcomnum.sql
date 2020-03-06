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

Date: 2018-07-25 16:12:34
*/


-- ----------------------------
-- Table structure for ims_infrastructure_dsdequipcomnum
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_dsdequipcomnum";
CREATE TABLE "xxyg"."ims_infrastructure_dsdequipcomnum" (
"dictid" varchar(20) COLLATE "default",
"time" timestamp(6),
"sums" numeric,
"upcorpname" varchar(100) COLLATE "default",
"corpcode" varchar(50) COLLATE "default",
"corpanme" varchar(200) COLLATE "default",
"upcorpcode" varchar(50) COLLATE "default",
"mapname" varchar(200) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."dictid" IS '设备类别编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."time" IS '时间';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."sums" IS '总设备数量';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."upcorpname" IS '省级单位名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."corpcode" IS '单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."corpanme" IS '地市级单位名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."upcorpcode" IS '上级单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_dsdequipcomnum"."mapname" IS '地图名称';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
