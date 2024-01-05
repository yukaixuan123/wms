using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Roles;
using WMS.AppService.Dtos.Sys;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Sys;

namespace WMS.AppService.AppService.Sys
{
    public class Sys_encodeAppService:ISys_encodeAppService
    {
        private readonly  ISys_encodeRepository sys;

        private readonly IMapper mapper;

        public Sys_encodeAppService(ISys_encodeRepository sys,IMapper mapper)
        {
            this.sys = sys;
            this.mapper = mapper;
        }

        public async Task<bool> AddSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime create_time, string create_by, int dict_id, string is_default, string is_del)
        {
            return await sys.AddSys_dict_data(dict_label, dict_value, dict_type, dict_name, status, remark, create_time, create_by,dict_id,is_default,is_del);
        }

        public async Task<bool> AddSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime create_time, string create_by, string is_del)
        {
            return await sys.AddSys_dict_type(dict_name,dict_label,status,remark,create_time,create_by,is_del);
        }

        public async Task<bool> DeleteBs_item_type(string item_type_code)
        {
           return await sys.DeleteBs_item_type(item_type_code);
        }

        public async Task<bool> Delete_dict_data(string is_del, int dict_code)
        {
            return await sys.Delete_dict_data(is_del,dict_code);
        }

        public async Task<bool> Delete_dict_type(string is_del, int dict_id)
        {
            return await sys.Delete_dict_type(is_del,dict_id);
        }

        public async Task<IEnumerable<Bs_item_type>> FindBs_item_type(string item_type_code)
        {
            return await sys.FindBs_item_type(item_type_code);
        }

        public async Task<IEnumerable<Sys_dict_data>> FindDataById(int dict_id)
        {
           return await sys.FindDataById(dict_id);
        }

        public async Task<IEnumerable<Bs_item_type>> FindFather(int father_code)
        {
            return await sys.FindFather(father_code);
        }


        public async Task<IEnumerable<Sys_dict_type>> FindSys_dict_type(int dict_id)
        {
            return  await sys.FindSys_dict_type(dict_id);
        }

        public string FindSys_encodeById(string id)
        {
            return sys.FindSys_encodeById(id);
        }

        public Task<IEnumerable<Sys_encode>> FindXlk()
        {
            return sys.FindXlk();
        }

        public async Task<FenYeUsers<Sys_dict_data>> Find_dict_data(int PageSize, int CurrentPage, string str)
        {
            return await sys.Find_dict_data(PageSize, CurrentPage, str);
        }

        public async Task<FenYeUsers<Sys_dict_type>> Find_dict_type(int PageSize, int CurrentPage, string str)
        {
            return await sys.Find_dict_type(PageSize, CurrentPage, str);
        }

        //规则分页条件查询
        public FenYe<Sys_encode> Sys_encodeSelect(int page, int pageSize, string from, string qz, string gz, string time)
        {
            return sys.Sys_encodeSelect(page,pageSize,from,qz,gz,time);
        }

        public async Task<bool> UpdateSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime update_time, string update_by, int dict_code, string is_default)
        {
            return await sys.UpdateSys_dict_data(dict_label,dict_value,dict_type,dict_name,status,remark,update_time,update_by,dict_code,is_default);
        }

        public async Task<bool> UpdateSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime update_time, string update_by, int dict_id)
        {
            return await sys.UpdateSys_dict_type(dict_name, dict_label, status, remark, update_time, update_by,dict_id);
        }

        public Task<bool> UpdateSys_encodeAsyn(int en_code, string en_prefix, string en_time, int en_num, int en_step, string en_rules, string create_by, DateTime create_time)
        {
            return sys.UpdateSys_encodeAsyn(en_code,en_prefix,en_time,en_num,en_step,en_rules,create_by,create_time);
        }
    }
}
