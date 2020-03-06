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

Date: 2018-07-25 16:22:52
*/


-- ----------------------------
-- Table structure for ims_infrastructure_yygk_99002
-- ----------------------------
DROP TABLE IF EXISTS "xxyg"."ims_infrastructure_yygk_99002";
CREATE TABLE "xxyg"."ims_infrastructure_yygk_99002" (
"id" varchar(50) COLLATE "default",
"hostname" varchar(200) COLLATE "default",
"ostype" varchar(100) COLLATE "default",
"corpcode" varchar(19) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99002"."id" IS '系统配置项ID';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99002"."hostname" IS '服务器名称';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99002"."ostype" IS '操作系统类型';
COMMENT ON COLUMN "xxyg"."ims_infrastructure_yygk_99002"."corpcode" IS '单位编码';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------
