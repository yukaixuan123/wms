using Azure;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace WMS.EFCore.Repository.Wh
{
    public class Wh_buy_order_hRepository : IWh_buy_order_hRepository
    {
        private readonly MyContext myContext;
        public Wh_buy_order_hRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }

        /// <summary>
        /// 根本进货单号查进货订单
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<View_Order> Wh_buy_order_h_CodeAsyunc(string buy_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[view_Order] where buy_code='{buy_code}'";
                return await connection.QueryFirstAsync<View_Order>(sql);
            }
        }

        public async Task<IEnumerable<Wh_orderbuy_d>> Wh_buy_order_h_Code1Asyunc(string buy_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Wh_orderbuy_d] where buy_code='{buy_code}'";
                return await connection.QueryAsync<Wh_orderbuy_d>(sql);
            }
        }
        public async Task<IEnumerable<ST1>> Wh_buy_order_h_Code2Asyunc(string buy_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[ST] WHERE buy_code='{buy_code}' ";
                return await connection.QueryAsync<ST1>(sql);
            }
        }
        /// <summary>
        /// 进货订单删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_buy_order_h_DeleteAsync(int buy_codeId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_buy_order_h] set is_del=1 where buy_codeId='{buy_codeId}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 进货订单批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        public async Task<bool> Wh_buy_order_h_DeleteArryAsync(int[] carModel)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < carModel.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_buy_order_h] set is_del=1 where buy_codeId='{carModel[i]}'";
                    await con.ExecuteAsync(sql);
                }
                return true;
            }
        }

        /// <summary>
        /// 进货订单添加
        /// </summary>
        /// <param name="sg"></param>
        /// <param name="gg"></param>
        /// <returns></returns>
        public async Task<bool> Wh_buy_order_h_InsertAsync(List<Wh_orderbuy_d> dd, Wh_buy_order_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"insert into [dbo].[Wh_buy_order_h](buy_code, buy_date, supply_code, link_man, link_way, buy_man, remark,create_by)
                values('{h.buy_code}','{h.buy_date}','{h.supply_code}','{h.link_man}','{h.link_way}','{h.buy_man}','{h.remark}','{h.create_by}')";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_orderbuy_d](buy_code, item_name, item_code, model_code, unit, item_type_name, buy_num, buy_goods_money,remark)
                        values('{h.buy_code}','{item.item_name}','{item.item_code}','{item.model_code}','{item.unit}','{item.item_type_name}','{item.buy_num}','{item.buy_goods_money}','{item.remark}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }
        /// <summary>
        /// 进货订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        public async Task<bool> Wh_buy_order_h_UpdateAsync(List<Wh_orderbuy_d> dd, Wh_buy_order_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_buy_order_h] set buy_date='{h.buy_date}',supply_code='{h.supply_code}',link_man='{h.link_man}',link_way='{h.link_way}',buy_man='{h.buy_man}',remark='{h.remark}',create_by='{h.create_by}' where buy_code='{h.buy_code}'";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    string sql1 = $@"delete from [dbo].[Wh_orderbuy_d] where buy_code='{h.buy_code}'";
                    await connection.ExecuteAsync(sql1);
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_orderbuy_d](buy_code, item_name, item_code, model_code, unit, item_type_name, buy_num, buy_goods_money,remark)
                        values('{h.buy_code}','{item.item_name}','{item.item_code}','{item.model_code}','{item.unit}','{item.item_type_name}','{item.buy_num}','{item.buy_goods_money}','{item.remark}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }
        /// <summary>
        /// 进货订单
        /// </summary>
        /// <param name="fenYe"></param>
        /// <returns></returns>
        public async Task<FenYeDapper<View_Order>> Wh_buy_order_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "buy_codeId");
                dynamicParameters.Add("@tableName", "View_Order");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeDapper<View_Order> fenYe = new FenYeDapper<View_Order>();
                fenYe.List = await con.QueryAsync<View_Order>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

        /// <summary>
        /// 货品信息
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<FenYeDapper<View_Bs_Item>> Bs_item_FenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "item_id");
                dynamicParameters.Add("@tableName", "View_Bs_Item");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeDapper<View_Bs_Item> fenYe = new FenYeDapper<View_Bs_Item>();
                fenYe.List = await con.QueryAsync<View_Bs_Item>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }
        /// <summary>
        /// 根据用户,密码查用户信息
        /// </summary>
        /// <param name="username"></param>
        /// <param name="password"></param>
        /// <returns></returns>
        public async Task<Users> UsersID(string username, string password)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"SELECT * FROM [dbo].[Users] Where U_name='{username}' and U_password='{password}'";
                return await con.QueryFirstOrDefaultAsync<Users>(sql);
            }
        }
        /// <summary>
        /// 审核状态
        /// </summary>
        /// <param name="sale_state"></param>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_buy_order_h_sale_stateAsync(string sale_state, string sure_man, int buy_codeId,string sale_state_yj)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_buy_order_h] set sale_state='{sale_state}',sure_man='{sure_man}',sure_date=getdate(),sale_state_yj='{sale_state_yj}' where buy_codeId='{buy_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<bool> Wh_buy_order_h_chexiaoAsync(string sure_man, int buy_codeId) 
        { 
        
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_buy_order_h] set sale_state=0,sure_man='{sure_man}',sure_date=getdate() where buy_codeId='{buy_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 用户信息
        /// </summary>
        /// <returns></returns>
        public Task<List<Users>> UserFind()
        {
            return myContext.user.Where(p => p.is_del.Contains("0")).ToListAsync();
        }
        /// <summary>
        /// 供应商信息
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_supply>> SuplyFind()
        {
           return myContext.super.Where(p => p.is_del.Contains("0")).ToListAsync();
        }
        /// <summary> 
        /// 根据名字供应商信息
        /// </summary>
        /// <returns></returns>
        public async Task<Bs_supply> SuplyFindName(string name)
        {
            return await myContext.super.FirstOrDefaultAsync(p => p.supply_name == name);
        }
    }
}
