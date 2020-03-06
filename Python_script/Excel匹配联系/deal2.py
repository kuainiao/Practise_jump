# -*- coding: utf-8 -*
# pip3 install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com pandas
import pandas as pd
import uuid
import xlrd

org_name_list = []  # 存放上级业务名称集合
org_sub_id_list = []  # 存放业务组织id集合
finaltest = []

# 读取已存在IOS的组织和上级组织id
ios_guangxi_worksheet=xlrd.open_workbook("ios_guangxi.xlsx")
ios_guangxi_worksheet=ios_guangxi_worksheet.sheet_by_index(0)
ios_guangxi_worksheet_nrows=ios_guangxi_worksheet.nrows

for i in range(ios_guangxi_worksheet_nrows-1):
    item_name=ios_guangxi_worksheet.row_values(i+1)
    org_name=item_name[11]
    char_num = org_name.count("\\")  # 统计层数
    before_org_name = org_name.split("\\")
    before_org_name = org_name.split(before_org_name[char_num-1])
    before_org_name = before_org_name[0]
    if before_org_name not in org_name_list:
        org_name_list.append(before_org_name)
        org_sub_id_list.append(item_name[5])
#before_org_name="\\4A平台基准组织\\中国南方电网有限责任公司\\广西电网有限责任公司\\广西电网有限责任公司河池供电局\\"
#print(before_org_name not in org_name_list)


# 读取缺失组织名称
f = open("./exsit_org_name.txt")
for org_name in f:
    # print(org_name)
    # 取上一层组织
    char_num = org_name.count("\\")  # 统计层数,6
    before_org_name = org_name.split("\\")
    before_org_name = org_name.split(before_org_name[char_num])
    before_org_name = before_org_name[0]
    # 判断上级组织是否被收录
    if before_org_name not in org_name_list:
        # 生产唯一uuid
        namespace = uuid.NAMESPACE_URL
        org_uuid = str(uuid.uuid5(namespace, before_org_name))
        org_uuid = org_uuid.replace("-", "")
        # 存入组织名到集合
        org_name_list.append(before_org_name)
        org_sub_id_list.append(org_uuid)
org_all_list = pd.Series(org_sub_id_list, index=org_name_list)
#print(org_all_list['\\4A平台基准组织\\中国南方电网有限责任公司\\广西电网有限责任公司\\广西电网有限责任公司河池供电局\\'])

exsit_bussiness_id = []
f = open("./exsit_bussiness_id.txt")
for m1 in f:
    exsit_bussiness_id.append(m1)
exsit_sub_bussiness_id = []
f = open("./exsit_sub_bussiness_id.txt")
for m2 in f:
    exsit_sub_bussiness_id.append(m2)


number = 0
# 找上级组织id
f = open("./exsit_org_name.txt")
for org_name in f:
    # print(org_name)
    # 生产唯一uuid
    namespace = uuid.NAMESPACE_URL
    org_uuid = str(uuid.uuid5(namespace, org_name))
    org_uuid = org_uuid.replace("-", "")
    # 生产唯一业务id
    namespace = uuid.NAMESPACE_URL
    org_sub_uuid = str(uuid.uuid3(namespace, org_name))
    org_sub_uuid = org_sub_uuid.replace("-", "")
    # 取上一层组织
    char_num = org_name.count("\\")  # 统计层数,6
    before_org_name = org_name.split("\\")
    only_org_name = before_org_name[char_num]
    before_org_name = org_name.split(before_org_name[char_num])
    before_org_name = before_org_name[0]
    # 取上级业务id
    before_org_id = org_all_list[before_org_name]
    # 组装字符串到集合
    finalstr = str(only_org_name) + "；" + str(org_sub_uuid) + "；" + str(before_org_id) + "；" + str(
        exsit_bussiness_id[number]) + "；" + str(exsit_sub_bussiness_id[number]) + "；" + str(org_name) + "；"
    # 去掉回车符号
    finalstr = finalstr.replace("\n", "")
    finalstr = finalstr + "\n"
    # finalstr =str(only_org_name)+";"
    finaltest.append(finalstr)
    number = number + 1

# 组装字符串写入txt文件
with open("finaltest.txt", "w") as f:
    for i in range(len(finaltest)):
        f.write(finaltest[i])

# 放集合：https://www.cnblogs.com/liulangmao/p/9206810.html

# 思路：拿到所有上级组织和上级组织id，每次放进去先判断自己的上级组织id是否存在，存在就不放了，最后再遍历一次，拿到各自对应的上级组织id
