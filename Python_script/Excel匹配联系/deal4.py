import xlrd
import pandas as pd

jizhun_worksheet = xlrd.open_workbook("jizhun_data.xlsx")
jizhun_worksheet = jizhun_worksheet.sheet_by_index(0)
jizhun_nrows = jizhun_worksheet.nrows

hrid_id = []  # 存储人资id
exsit_bussiness_id = []  # 存储业务id

for i in range(jizhun_nrows-1):
    item_name = jizhun_worksheet.row_values(i + 1)
    hrid = item_name[4]
    bussiness_id = item_name[0]
    hrid_id.append(hrid)
    exsit_bussiness_id.append(bussiness_id)
org_all_list = pd.Series(hrid_id, index=exsit_bussiness_id)

fianl_worksheet = xlrd.open_workbook("hr_fianl.xlsx")
fianl_worksheet = fianl_worksheet.sheet_by_index(0)
fianl_nrows = fianl_worksheet.nrows

ffff_id=[]
for i in range(fianl_nrows-1):
    item_name = fianl_worksheet.row_values(i + 1)
    bzid = item_name[3]
    ffff_id.append(org_all_list[bzid]+'\n')

with open("ffff_id.txt", "w") as f:
    for i in range(len(ffff_id)):
        f.write(ffff_id[i])