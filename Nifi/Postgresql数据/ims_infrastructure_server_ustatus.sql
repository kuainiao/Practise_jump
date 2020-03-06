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

Date: 2018-07-26 15:31:00
*/


-- ----------------------------
-- Table structure for ims_infrastructure_server_ustatus
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_server_ustatus";
CREATE TABLE "xxyg"."ims_infrastructure_server_ustatus" (
"unitcode" varchar(20) COLLATE "default",
"unitname" varchar(100) COLLATE "default",
"time" timestamp(6),
"states" int4,
"num" int4
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_server_ustatus"."unitcode" IS '单位编码';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_server_ustatus"."unitname" IS '单位名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_server_ustatus"."time" IS '时间';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_server_ustatus"."states" IS '设备状态0:正常,1:异常';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_server_ustatus"."num" IS '设备数量';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
