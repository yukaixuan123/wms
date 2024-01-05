using Dapper;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;

namespace WMS.EFCore.Repository.Wh
{
    public class Wh_sale_hRepository:IWh_sale_hRepository
    {
        private readonly MyContext myContext;
        public Wh_sale_hRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }
        /// <summary>
        /// 查客户信息
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<Bs_customer>> Wh_sale_hYHAsyunc()
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Bs_customer]";
                return await connection.QueryAsync<Bs_customer>(sql);
            }
        }

        /// <summary>
        /// 根据客户名称查全部信息
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<Bs_customer> Wh_sale_hNameAsyunc(string cust_name)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select  * from [dbo].[Bs_customer] where cust_name='{cust_name}'";
                return await connection.QueryFirstAsync<Bs_customer>(sql);
            }
        }

        /// <summary>
        /// 销售订单添加
        /// </summary>
        /// <param name="sg"></param>
        /// <param name="gg"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_h_InsertAsync(List<Wh_sale_d> dd, Wh_sale_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"insert into [dbo].[Wh_sale_h](sale_code, sale_date, cust_code, link_man, link_way, sale_duty_man, create_by, remark)
                            values('{h.sale_code}','{h.sale_date}','{h.cust_code}','{h.link_man}','{h.link_way}','{h.sale_duty_man}','{h.create_by}','{h.remark}')";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_sale_d](sale_code, item_name,item_code, model_code, unit, item_type_name, inbill3_num,  sale_price, remark)
                                values('{h.sale_code}','{item.item_name}','{item.item_code}','{item.model_code}','{item.unit}','{item.item_type_name}','{item.inbill3_num}','{item.sale_price}','{item.remark}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }

        /// <summary>
        /// 销售订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_h_UpdateAsync(List<Wh_sale_d> dd, Wh_sale_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_h] set sale_date='{h.sale_date}',cust_code='{h.cust_code}',link_man='{h.link_man}',link_way='{h.link_way}',sale_duty_man='{h.sale_duty_man}',remark='{h.remark}' where sale_code='{h.sale_code}'";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    string sql1 = $@"delete from [dbo].[Wh_sale_d] where sale_code='{h.sale_code}'";
                    await connection.ExecuteAsync(sql1);
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_sale_d](sale_code, item_name,item_code, model_code, unit, item_type_name, inbill3_num,  sale_price, remark)
                                values('{h.sale_code}','{item.item_name}','{item.item_code}','{item.model_code}','{item.unit}','{item.item_type_name}','{item.inbill3_num}','{item.sale_price}','{item.remark}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }

        /// <summary>
        /// 销售订单查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>

        public async Task<FenYeDapper<View_Sale_h>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "sale_codeId");
                dynamicParameters.Add("@tableName", "view_Sale");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeDapper<View_Sale_h> fenYe = new FenYeDapper<View_Sale_h>();
                fenYe.List = await con.QueryAsync<View_Sale_h>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

        /// <summary>
        /// 销售货品查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<FenYeDapper<View_XSGoods>> Wh_sale_hGoodsFenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "item_id");
                dynamicParameters.Add("@tableName", "view_XSGoods");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeDapper<View_XSGoods> fenYe = new FenYeDapper<View_XSGoods>();
                fenYe.List = await con.QueryAsync<View_XSGoods>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }


        /// <summary>
        /// 销售订单删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_h_DeleteAsync(int sale_codeId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_sale_h] set is_del=1 where sale_codeId='{sale_codeId}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        /// <summary>
        /// 进货订单批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_h_DeleteArryAsync(int[] carModel)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < carModel.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_sale_h] set is_del=1 where sale_codeId='{carModel[i]}'";
                    await con.ExecuteAsync(sql);
                }
                return true;
            }
        }


        /// <summary>
        /// 根本销售单号查销售订单
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<View_Sale_h> Wh_sale_h_CodeAsyunc(string sale_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[view_Sale] where sale_code='{sale_code}'";
                return await connection.QueryFirstAsync<View_Sale_h>(sql);
            }
        }
        /// <summary>
        /// 销售订单明细
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_sale_d>> Wh_sale_h_Code1Asyunc(string sale_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Wh_sale_d] where sale_code='{sale_code}'";
                return await connection.QueryAsync<Wh_sale_d>(sql);
            }
        }
        /// <summary>
        /// 销售出库
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<ST2>> Wh_sale_h_Code2Asyunc(string sale_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[ST1] where sale_code='{sale_code}' ";
                return await connection.QueryAsync<ST2>(sql);
            }
        }
        /// <summary>
        /// 审核状态
        /// </summary>
        /// <param name="sale_state"></param>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_h__sale_stateAsync(string sale_state, string sure_man, int sale_codeId, string sure_yj)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_h] set sale_state='{sale_state}',sure_man='{sure_man}',sure_date=getdate(),sure_yj='{sure_yj}' where sale_codeId='{sale_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_h__chexiaoAsync(string sure_man, int sale_codeId)
        {

            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_h] set sale_state='0',sure_man='{sure_man}' where sale_codeId='{sale_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
    }
}
