using Dapper;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using OfficeOpenXml.Table.PivotTable;
using System.Data.SqlClient;
using WMS.AppService.AppService.Cm;
using WMS.AppService.AppService.Sys;
using WMS.AppService.Dtos.Cm;
using WMS.AppService.Dtos.Sys;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Sys;

namespace WMS.Controllers.Sys
{
    [Route("api/[controller]/[action]")]
    [ApiController]
    public class Sys_encodeController : ControllerBase
    {
        private readonly ISys_encodeAppService sys;

        public Sys_encodeController(ISys_encodeAppService sys)
        {
            this.sys = sys;
        }
        [HttpGet]

        public IActionResult Sys_encodeFenYeAsync(int page, int pageSize, string from = null, string qz = null, string gz = null,string time=null)
        {
            var products = sys.Sys_encodeSelect(page, pageSize, from, qz, gz,time);

            return Ok(products);
        }
        [HttpPut]
        public async Task<bool> Sys_encodeUpdateAsync(int en_code, string en_prefix, string en_time, int en_num, int en_step, string en_rules, string create_by, DateTime create_time)
        {
            return await sys.UpdateSys_encodeAsyn(en_code,en_prefix,en_time,en_num,en_step,en_rules,create_by, create_time);
        }
        [HttpGet]
        public Task<IEnumerable<Sys_encode>> FindXlk()
        {
            return sys.FindXlk();
        }

        [HttpGet]
        public string FindSys_encodeById(string id)
        {
            return sys.FindSys_encodeById(id);
        }
        [HttpGet]
        public async Task<FenYeUsers<Sys_dict_data>> FindDictData(int PageSize, int CurrentPage, string str)
        {
            return await sys.Find_dict_data(PageSize,CurrentPage,str);
        }
        [HttpPost]
        public async Task<bool> AddSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime create_time, string create_by, string is_del)
        {
            return await sys.AddSys_dict_type(dict_name, dict_label, status, remark, create_time, create_by,is_del);
        }
        [HttpGet]
        public async Task<FenYeUsers<Sys_dict_type>> Find_dictType(int PageSize, int CurrentPage, string str)
        {
            return await sys.Find_dict_type(PageSize,CurrentPage,str);
        }
        [HttpPut]
        public async Task<bool> UpdateSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime update_time, string update_by, int dict_id)
        {
            return await sys.UpdateSys_dict_type(dict_name, dict_label, status, remark, update_time, update_by, dict_id);
        }

        [HttpPut]
        public async Task<bool> Delete_dict_type(string is_del,int dict_id)
        {
            return await sys.Delete_dict_type(is_del, dict_id);
        }
        [HttpPost]

        public async Task<bool> AddSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime create_time, string create_by, int dict_id,string is_default,string is_del)
        {
            return await sys.AddSys_dict_data(dict_label, dict_value, dict_type, dict_name, status, remark, create_time, create_by, dict_id,is_default, is_del);
        }
        [HttpPut]

        public async Task<bool> UpdateSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime update_time, string update_by, int dict_code,string is_default)
        {
            return await sys.UpdateSys_dict_data(dict_label, dict_value, dict_type, dict_name, status, remark, update_time, update_by,dict_code,is_default);
        }
        [HttpPut]
        public async Task<bool> Delete_dict_data(string is_del, int dict_code)
        {
            return await sys.Delete_dict_data(is_del,dict_code);
        }

        [HttpGet]
        public async Task<IEnumerable<Sys_dict_data>> FindDataById(int dict_id)
        {
            return await sys.FindDataById(dict_id);
        }
        [HttpGet]
        public async Task<IEnumerable<Sys_dict_type>> FindSys_dict_type(int dict_id)
        {
            return await sys.FindSys_dict_type(dict_id);
        }

        [HttpGet]

        public async Task<IEnumerable<Bs_item_type>> FindBs_item_type(string item_type_code)
        {
            return await sys.FindBs_item_type(item_type_code);
        }

        [HttpPut]
        public async Task<bool> DeleteBs_item_type(string item_type_code)
        {
            return await sys.DeleteBs_item_type(item_type_code);
        }

        [HttpGet]
        public async Task<IEnumerable<Bs_item_type>> FindFather(int father_code)
        {
            return await sys.FindFather(father_code);
        }

        [HttpGet]
        public async Task<int> FindFather11(int father_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                
                    string sql = $"SELECT COUNT(*) FROM Bs_item_type WHERE father_code = @FatherCode";

                    // 使用参数化查询以防止 SQL 注入攻击
                    int count = await connection.ExecuteScalarAsync<int>(sql, new { FatherCode = father_code });

                    // 返回查询结果的数量
                    return count;
            }
        }


        [HttpGet]
        //public List<Bs_item_type> GetItems(string father_code)
        //{
        //    string query = "select item_type_code,item_type_name,father_code from Bs_item_type WHERE father_code = @father_code";
        //    List<Bs_item_type> result = new List<Bs_item_type>();

        //    using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
        //    {
        //        using (SqlCommand command = new SqlCommand(query, connection))
        //        {
        //            command.Parameters.AddWithValue("@father_code", father_code);
        //            connection.Open();
        //            using (SqlDataReader reader = command.ExecuteReader())
        //            {
        //                while (reader.Read())
        //                {
        //                    Bs_item_type menuItem = new Bs_item_type();
        //                    menuItem.item_type_code = reader.GetString(0);
        //                    menuItem.item_type_name = reader.GetString(1);
        //                    menuItem.children = GetItems(menuItem.item_type_code);
        //                    result.Add(menuItem);
        //                }
        //            }
        //        }
        //    }
        //    return result;
        //}

        public List<Bs_item_type> GetItems(string father_code)
        {

            string query = "select item_type_code,item_type_name,father_code from BS_item_type WHERE father_code =@father_code ";
            List<Bs_item_type> result = new List<Bs_item_type>();

            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@father_code", father_code);
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Bs_item_type menuItem = new Bs_item_type();
                            menuItem.item_type_code = reader.GetString(0);
                            menuItem.item_type_name = reader.GetString(1);
                            menuItem.children = GetItems(menuItem.item_type_code);
                            result.Add(menuItem);
                        }
                    }
                } 
            }
            return result;
        }
        [HttpGet]
        public async Task<Bs_item> FindGoodsIfoByItem_Id(int id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from  Bs_item where item_id='{id}'";
                return await connection.QueryFirstAsync<Bs_item>(sql);
            }
        }
    }
}
