# -*- coding: utf-8 -*
# pip3 install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com xlrd
import xlrd
import pandas as pd

guangxi_worksheet = xlrd.open_workbook("guangxi_lost.xlsx")
guangxi_worksheet = guangxi_worksheet.sheet_by_index(0)

jizhun_worksheet = xlrd.open_workbook("jizhun_data.xlsx")
jizhun_worksheet = jizhun_worksheet.sheet_by_index(0)
jizhun_nrows = jizhun_worksheet.nrows
jizhun_org_name = []

exsit_org_name = []
not_exsit_org_name = []

exsit_bussiness_id = []
exsit_sub_bussiness_id = []

x_exsit_bussiness_id = []
x_exsit_sub_bussiness_id = []

for i in range(jizhun_nrows):
    item_name = jizhun_worksheet.row_values(i)
    org_name = item_name[6]
    bussiness_id = item_name[0]
    sub_bussiness_id = item_name[2]
    jizhun_org_name.append(org_name)
    exsit_bussiness_id.append(bussiness_id)
    exsit_sub_bussiness_id.append(sub_bussiness_id)

exsit_bussiness_id_list = pd.Series(exsit_bussiness_id, index=jizhun_org_name)
exsit_sub_bussiness_id_list = pd.Series(exsit_sub_bussiness_id, index=jizhun_org_name)

# 保存ios组织数据
ios_guangxi_worksheet = xlrd.open_workbook("ios_guangxi.xlsx")
ios_guangxi_worksheet = ios_guangxi_worksheet.sheet_by_index(0)
ios_guangxi_nrows = ios_guangxi_worksheet.nrows

# 存储当前组织id的全路径
ios_sub_id_allpath = {}
# 存储当前组织id的中文
ios_sub_id_allpath_ch = {}

for i in range(ios_guangxi_nrows):
    item_name = ios_guangxi_worksheet.row_values(i)
    biz_org_id = item_name[0]
    parent_biz_org_id = item_name[5]
    org_name = item_name[2]
    if parent_biz_org_id in ios_sub_id_allpath.keys():
        allpath = "/" + ios_sub_id_allpath[parent_biz_org_id] + "/" + biz_org_id  # 保存全路径
        ios_sub_id_allpath[biz_org_id] = allpath  # 把全路径保存在里面
    else:
        allpath = "/" + biz_org_id  # 保存全路径
        ios_sub_id_allpath[biz_org_id] = allpath  # 把全路径保存在里面



guangxi_nrows = guangxi_worksheet.nrows
for i in range(guangxi_nrows):
    item_name = guangxi_worksheet.row_values(i)
    guangxi_org_name = "\\4A平台基准组织\\中国南方电网有限责任公司\\" + item_name[1]
    if guangxi_org_name not in jizhun_org_name:
        print('需补充:' + guangxi_org_name)
        not_exsit_org_name.append(guangxi_org_name)
    else:
        print('已存在:' + guangxi_org_name)
        exsit_org_name.append(guangxi_org_name)
        x_exsit_bussiness_id.append(exsit_bussiness_id_list[guangxi_org_name])
        x_exsit_sub_bussiness_id.append(exsit_sub_bussiness_id_list[guangxi_org_name])

with open("exsit_org_name.txt", "w") as f:
    for i in range(len(exsit_org_name)):
        f.write(exsit_org_name[i] + '\n')

with open("not_exsit_org_name.txt", "w") as f:
    for i in range(len(not_exsit_org_name)):
        f.write(not_exsit_org_name[i] + '\n')

with open("exsit_bussiness_id.txt", "w") as f:
    for i in range(len(x_exsit_bussiness_id)):
        f.write(str(x_exsit_bussiness_id[i]) + '\n')

with open("exsit_sub_bussiness_id.txt", "w") as f:
    for i in range(len(x_exsit_sub_bussiness_id)):
        f.write(str(x_exsit_sub_bussiness_id[i]) + '\n')
