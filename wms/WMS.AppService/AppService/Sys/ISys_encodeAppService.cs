using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity;
using WMS.AppService.Dtos.Sys;
using WMS.Domain.Entity.Cm;

namespace WMS.AppService.AppService.Sys
{
    public interface ISys_encodeAppService
    {
        Task<IEnumerable<Sys_encode>> FindXlk();

        FenYe<Sys_encode> Sys_encodeSelect(int page, int pageSize, string from, string qz, string gz, string time);

        //修改
        Task<bool> UpdateSys_encodeAsyn(int en_code,string en_prefix,string en_time,int en_num,int en_step,string en_rules,string create_by, DateTime create_time);

        //步长
        string FindSys_encodeById(string id);

        //查询字典
        Task<FenYeUsers<Sys_dict_data>> Find_dict_data(int PageSize,int CurrentPage, string str);
        //新增字典
        Task<bool> AddSys_dict_type(string dict_name,string dict_label,string status,string remark,DateTime create_time,string create_by, string is_del);

        Task<bool> UpdateSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime update_time, string update_by,int dict_id);

        Task<FenYeUsers<Sys_dict_type>> Find_dict_type(int PageSize, int CurrentPage, string str);

        Task<bool> Delete_dict_type(string is_del, int dict_id);

        Task<bool> AddSys_dict_data(string dict_label,string dict_value,string dict_type,string dict_name,string status,string remark,DateTime create_time,string create_by,int dict_id,string is_default, string is_del);

        Task<bool> UpdateSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime update_time, string update_by,int dict_code,string is_default);

        Task<bool> Delete_dict_data(string is_del, int dict_code);

       Task<IEnumerable<Sys_dict_data>>FindDataById(int dict_id);


        Task<IEnumerable<Sys_dict_type>> FindSys_dict_type(int dict_id);

        Task<IEnumerable<Bs_item_type>> FindBs_item_type(string item_type_code);

        Task<bool> DeleteBs_item_type(string item_type_code);

        Task<IEnumerable<Bs_item_type>> FindFather(int father_code);
    }
}
