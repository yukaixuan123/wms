using Dapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.UserRoleView;
using WMS.Domain.Repository.Sys;

namespace WMS.EFCore.Repository.Sys
{
    public class Sys_encodeRepository : ISys_encodeRepository
    {

        private readonly MyContext myContext;
        public Sys_encodeRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }

        public async Task<bool> AddSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime create_time, string create_by, int dict_id, string is_default, string is_del)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"INSERT INTO Sys_dict_data(dict_label,dict_value,dict_type,dict_name,status,remark,create_time,create_by,dict_id,is_default,is_del)VALUES('{dict_label}','{dict_value}','{dict_type}','{dict_name}','{status}','{remark}',getdate(),'{create_by}','{dict_id}','{is_default}','{is_del}')";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
          }

        public async Task<bool> AddSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime create_time, string create_by, string is_del)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"INSERT INTO Sys_dict_type(dict_name,dict_label,status,remark,create_time,create_by,is_del)values('{dict_name}','{dict_label}','{status}','{remark}',getdate(),'{create_by}','{is_del}')";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<bool> Delete_dict_data(string is_del, int dict_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update Sys_dict_data set is_del='{is_del}' where dict_id='{dict_code}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<bool> Delete_dict_type(string is_del,int dict_id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update Sys_dict_type set is_del='{is_del}' where dict_id='{dict_id}'";
                return await connection.ExecuteAsync(sql)>0 ? true: false;
            }
         }

        public async Task<IEnumerable<Sys_dict_data>> FindDataById(int dict_id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM Sys_dict_data WHERE dict_id='{dict_id}'";
                return await connection.QueryAsync<Sys_dict_data>(sql);
            }
         }

        public string FindSys_encodeById(string id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"SELECT TOP 1 *
                    FROM Sys_encode
                  where en_code={id} ";
                Sys_encode sys = connection.QueryFirst<Sys_encode>(sql);

                int cd = sys.en_time.Length;
                string[] code = new string[cd];
                for (int i = 1; i <= cd; i++)
                {
                    if (i==cd)
                    {
                        code[i - 1] = sys.en_time.Substring(sys.en_time.Length-1);
                    }
                    else
                    {
                        code[i - 1] = sys.en_time.Substring(i- 1,i);
                    }
                }
                string sun = "";
                for (int i = 0; i < code.Length; i++)
                {
                    switch (code[i])
                    {
                        case "年":
                            sun = DateTime.Now.Year.ToString();
                        break;
                        case "月":
                            sun = DateTime.Now.Month.ToString();
                            break;
                        case "日":
                            sun = DateTime.Now.Day.ToString();
                            break;
                        case "时":
                            sun = DateTime.Now.Hour.ToString();
                            break;
                        case "分":
                            sun = DateTime.Now.Minute.ToString();
                            break;
                        case "秒":
                            sun = DateTime.Now.Second.ToString();
                            break;
                    }
                }               
                string shu = "";
                int weishu = 0;
                if (sys.en_max != null)
                {
                    weishu = Convert.ToInt32(sys.en_max) + sys.en_step;
                    string sql2 = $"update [dbo].[SYS_encode] set en_max={weishu} where en_code={id}";
                    connection.Execute(sql2);

                }
                if (weishu >= 10)
                {
                    sys.en_num -= 1;
                }
                for (int i = 1; i < sys.en_num; i++)
                {
                    shu += "0";
                }
                shu += weishu;
                return sys.en_prefix + sun + shu;

            }
        }

        public async Task<FenYeUsers<Sys_dict_data>> Find_dict_data(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "dict_code");
                param.Add("@tableName", "Sys_dict_data");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<Sys_dict_data> fenYe = new FenYeUsers<Sys_dict_data>();
                fenYe.List = await connection.QueryAsync<Sys_dict_data>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
         }

        public async Task<FenYeUsers<Sys_dict_type>> Find_dict_type(int PageSize, int CurrentPage, string str)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("@pageSize", PageSize);
                param.Add("@keyName", "dict_id");
                param.Add("@tableName", "Sys_dict_type");
                param.Add("@currentPage", CurrentPage);
                param.Add("@where", str);
                param.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec procFenYe_Where @pageSize, @keyName, @tableName, @currentPage, @where, @rows out ";
                FenYeUsers<Sys_dict_type> fenYe = new FenYeUsers<Sys_dict_type>();
                fenYe.List = await connection.QueryAsync<Sys_dict_type>(sql, param);
                fenYe.Rows = param.Get<int>("rows");
                return fenYe;

            }
        }

        public FenYe<Sys_encode> Sys_encodeSelect(int page, int pageSize, string from, string qz, string gz, string time)
        {
            if (page == 0) { page = 1; }
            var query = myContext.Sys_encode.AsQueryable();
            query = query.Where(p => p.is_del.Contains("0"));

            if (!string.IsNullOrEmpty(from))
            {
                query = query.Where(p => p.en_form.Contains(from));
            }
            if (!string.IsNullOrEmpty(qz))
            {
                query = query.Where(p => p.en_prefix.Contains(qz));
            }
            if (!string.IsNullOrEmpty(gz))
            {
                query = query.Where(p => p.en_time.Contains(gz));
            }
            if (!string.IsNullOrEmpty(time))
            {
                query = query.Where(p => p.create_time.Equals(time));
            }


            var totalCount = query.Count();

            var products = query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            return new FenYe<Sys_encode>(products, totalCount, page, pageSize);
        }

        public async Task<bool> UpdateSys_dict_data(string dict_label, string dict_value, string dict_type, string dict_name, string status, string remark, DateTime update_time, string update_by, int dict_code,string is_default)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"UPDATE Sys_dict_data SET dict_label='{dict_label}',dict_value='{dict_value}',dict_type='{dict_type}',dict_name='{dict_name}',status='{status}',remark='{remark}',update_time=getdate(),update_by='{update_by}',is_default='{is_default}' where dict_code='{dict_code}'";
                return await connection.ExecuteAsync(sql)>0 ? true:false;
            }
         }

        public async Task<bool> UpdateSys_dict_type(string dict_name, string dict_label, string status, string remark, DateTime update_time, string update_by, int dict_id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update Sys_dict_type set dict_name='{dict_name}',dict_label='{dict_label}',status='{status}',remark='{remark}',update_time=getdate(),update_by='{update_by}' where dict_id='{dict_id}'";
                return await connection.ExecuteAsync(sql)>0 ? true:false;
            }
         }

            public async Task<bool> UpdateSys_encodeAsyn(int en_code, string en_prefix, string en_time, int en_num, int en_step, string en_rules, string create_by, DateTime create_time)
        {

            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"UPDATE Sys_encode SET en_prefix ='{en_prefix}',en_time='{en_time}',en_num='{en_num}', en_step='{en_step}', en_rules='{en_rules}', create_by='{create_by}',create_time=getdate() where en_code='{en_code}'";
                return await connection.ExecuteAsync(sql)>0? true:false;
            }
        }

       //编码规则
       public async Task<IEnumerable<Sys_encode>> FindXlk()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select en_form from Sys_encode";
                return await connection.QueryAsync<Sys_encode>(sql);
            }
         }
       
        public async Task<IEnumerable<Sys_dict_type>> FindSys_dict_type(int dict_id)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM Sys_dict_data WHERE dict_id = '{dict_id}'";
                return await connection.QueryAsync<Sys_dict_type>(sql); ;
            }
          }

        public async Task<IEnumerable<Bs_item_type>> FindBs_item_type(string item_type_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM Bs_item WHERE item_type_code = '{item_type_code}'";
                return await connection.QueryAsync<Bs_item_type>(sql); ;
            }
          }

        public async Task<bool> DeleteBs_item_type(string item_type_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"UPDATE Bs_item_type SET is_del=1 WHERE item_type_code='{item_type_code}'";
                return await connection.ExecuteAsync(sql)>0 ? true :false ;
            }
         }

        public Task<IEnumerable<Bs_item_type>> FindFather(int father_code)
        {
            throw new NotImplementedException();
        }
    }
}
