import xlrd
import pandas as pd
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
    #org_name = "\\4A平台基准组织\\中国南方电网有限责任公司\\" +item_name[2]
    org_name = item_name[2]
    if parent_biz_org_id in ios_sub_id_allpath.keys():
        allpath = ios_sub_id_allpath[parent_biz_org_id] + "/" + biz_org_id  # 保存全路径
        ios_sub_id_allpath[biz_org_id] = allpath  # 把全路径保存在里面
    else:
        allpath = parent_biz_org_id+"/"+biz_org_id  # 保存全路径
        ios_sub_id_allpath[biz_org_id] = allpath  # 把全路径保存在里面
    ios_sub_id_allpath_ch[biz_org_id] = org_name

#print(ios_sub_id_allpath_ch)
final_str_list=[]
final_en_str_list=[]
for d,sub_id in ios_sub_id_allpath.items():
    before_org_name = sub_id.split("/")
    final_str = ""
    for borg_name in before_org_name:
        #print(borg_name)
        if borg_name in ios_sub_id_allpath_ch.keys():
            final_str=final_str+ios_sub_id_allpath_ch[borg_name]+'/'
    final_str_list.append(final_str+"\n")
    final_en_str_list.append(sub_id+"\n")

with open("final_str_list.txt", "w") as f:
    for i in range(len(final_str_list)):
        f.write(final_str_list[i])

with open("final_en_str_list.txt", "w") as f:
    for i in range(len(final_en_str_list)):
        f.write(final_en_str_list[i])
