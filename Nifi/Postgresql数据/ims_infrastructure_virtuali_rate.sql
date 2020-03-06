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

Date: 2018-07-26 15:31:09
*/


-- ----------------------------
-- Table structure for ims_infrastructure_virtuali_rate
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_virtuali_rate";
CREATE TABLE "xxyg"."ims_infrastructure_virtuali_rate" (
"unitcode" varchar(20) COLLATE "default",
"unitname" varchar(100) COLLATE "default",
"time" timestamp(6),
"vivalue" numeric
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_virtuali_rate"."unitcode" IS '单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_virtuali_rate"."unitname" IS '单位名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_virtuali_rate"."time" IS '时间';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_virtuali_rate"."vivalue" IS '虚拟化率';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
