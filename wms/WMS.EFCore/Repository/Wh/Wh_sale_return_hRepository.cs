using Dapper;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace WMS.EFCore.Repository.Wh
{
    public class Wh_sale_return_hRepository: IWh_sale_return_hRepository
    {
        private readonly MyContext myContext;

        public Wh_sale_return_hRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }
        /// <summary>
        /// 销售退货添加
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_return_h_InsertAsync(List<Wh_sale_return_d> dd, Wh_sale_return_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"insert into [dbo].[Wh_sale_return_h](sr_code, sr_date, sale_code, cust_code, link_man, link_way, sale_duty_man, create_by,return_money,buy_price,return_num, remark, remarks)
                                values('{h.sr_code}','{h.sr_date}','{h.sale_code}','{h.cust_code}','{h.link_man}','{h.link_way}','{h.sale_duty_man}','{h.create_by}','{h.return_money}','{h.buy_price}','{h.return_num}','{h.remark}','{h.remarks}')";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_sale_return_d](sr_code, item_name, item_code,inbill3_num, return_num,return_money,sale_price)
                                        values('{h.sr_code}','{item.item_name}','{item.item_code}','{item.inbill3_num}','{item.return_num}','{item.return_money}','{item.sale_price}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }


        /// <summary>
        /// 销售退货修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_return_h_UpdateAsync(List<Wh_sale_return_d> dd, Wh_sale_return_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_return_h] set sr_date='{h.sr_date}',remark='{h.remark}',remarks='{h.remarks}',return_num='{h.return_num}' ,return_money='{h.return_money}' where sr_code='{h.sr_code}'";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    string sql1 = $@"delete from [dbo].[Wh_sale_return_d] where sr_code='{h.sr_code}'";
                    await connection.ExecuteAsync(sql1);
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_sale_return_d](sr_code, item_name, item_code, return_num,return_money,sale_price)
                                        values('{h.sr_code}','{item.item_name}','{item.item_code}','{item.return_num}','{item.return_money}','{item.sale_price}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }

        /// <summary>
        /// 销售退货的查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<FenYeDapper<View_sale_return_h>> Wh_sale_return_h_FenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "sr_codeId");
                dynamicParameters.Add("@tableName", "view_sale_return_h");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeDapper<View_sale_return_h> fenYe = new FenYeDapper<View_sale_return_h>();
                fenYe.List = await con.QueryAsync<View_sale_return_h>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

        /// <summary>
        /// 根据退货单号查基本信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        public async Task<View_sale_return_h> Wh_sale_return_h_CodeAsyunc(string sr_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[view_sale_return_h] where sr_code='{sr_code}'";
                return await connection.QueryFirstAsync<View_sale_return_h>(sql);
            }
        }
        /// <summary>
        /// 根据退货单号查详细信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_sale_return_d>> Wh_sale_return_h_Code1Asyunc(string sr_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Wh_sale_return_d] where sr_code='{sr_code}'";
                return await connection.QueryAsync<Wh_sale_return_d>(sql);
            }
        }

        /// <summary>
        /// 根据销售订单查退货记录
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_sale_return_h>> Wh_sale_return_h__thjlAsyunc(string sale_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $" select * from [dbo].[Wh_sale_return_h] where sale_code='{sale_code}'";
                return await connection.QueryAsync<Wh_sale_return_h>(sql);
            }
        }
        /// <summary>
        /// 销售退货删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_return_h_DeleteAsync(int sr_codeId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_sale_return_h] set is_del=1 where sr_codeId='{sr_codeId}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_return_h_DeleteArryAsync(int[] carModel)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < carModel.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_sale_return_h] set is_del=1 where sr_codeId='{carModel[i]}'";
                    await con.ExecuteAsync(sql);
                }
                return true;
            }
        }
        /// <summary>
        /// 审核意见
        /// </summary>
        /// <param name="sale_state"></param>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <param name="sure_yj"></param>
        /// <returns></returns>

        public async Task<bool> Wh_sale_return_h_sale_stateAsync(List<Wh_sale_d> dd, Wh_sale_return_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_return_h] set sale_state='{h.sale_state}',sure_man='{h.sure_man}',sure_date=getdate(),sale_yj='{h.sale_yj}' where sr_codeId='{h.sr_codeId}'";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    foreach (var item in dd)
                    {
                        string ss = $@"update [dbo].[Wh_sale_d] set return_num=return_num+'{item.return_num}' where sale_code='{item.sale_code}'  ";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }



        public async Task<bool> Wh_sale_return_h_sale_inserAsync(List<Wh_saleReturn_dXX> dd, Wh_inbill_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                    string bb = "";
                    decimal ru = 0;
                    decimal wei = 0;
                    foreach (var item in dd)
                    {
                        bb = item.sr_code;
                        ru += item.change;
                        wei += item.inbill3_num;
                    }
                    string sql2 = $"update [dbo].[Wh_sale_return_h]  set sale_state='3'  where sr_code='{bb}'";
                    await connection.ExecuteAsync(sql2);
                    if (ru == wei)
                    {
                        string sql3 = $"update [dbo].[Wh_sale_return_h]  set sale_state='4'  where sr_code='{bb}'  ";
                        await connection.ExecuteAsync(sql3);
                    }
                   
                    string sql11 = $@"SELECT count(0) FROM [dbo].[Wh_inbill_h] where  inbill_bh='{h.inbill_bh}'";
                    var count= await connection.QueryFirstAsync<int>(sql11);
                    if (count > 0)
                    {

                        string sqlxg = $@"update [dbo].[Wh_inbill_h] set inbll_date='{h.inbll_date}',inbill_duty_man='{h.inbill_duty_man}',remark='{h.remark}',ware_name='{h.ware_name}' where inbill_bh='{h.inbill_bh}'";
                        await connection.ExecuteAsync(sqlxg);
                        foreach (var d in dd)
                        {
                            string sql81 = $@"update [dbo].[Wh_sale_return_d] set inbill3_num=inbill3_num-'{d.change}', ware_code='{h.ware_name}',area_code='{d.cw}' where sr_code='{d.sr_code}' and item_code='{d.item_code}' ";
                            await connection.ExecuteAsync(sql81);

                            string sqlxxx = $"update  [dbo].[Wh_inbill_d] set inbill_num=inbill_num+'{d.change}',area_code='{d.cw}',zong=(inbill_num+'{d.change}')*'{d.inbill_price}' where inbill_code='{h.inbill_bh}' and item_code='{d.item_code}' ";
                            await connection.ExecuteAsync(sqlxxx);
                        }
                    }
                    else
                    {

                        string sql6 = $"insert into [dbo].[Wh_inbill_h](inbill_type, inbill_state, create_time,create_by,inbll_date ,ware_name,inbill_bh,inbill_duty_man,buy_code,remark)values" +
                           $"('退货入库',0,getdate(),'{h.create_by}','{h.inbll_date}','{h.ware_name}','{h.inbill_bh}','{h.inbill_duty_man}','','{h.remark}')";
                         await connection.ExecuteAsync(sql6);
                        foreach (var d in dd)
                        {
                            string sql8 = $@"update [dbo].[Wh_sale_return_d] set ware_code='{h.ware_name}',area_code='{d.cw}' where sr_code='{d.sr_code}' and item_code='{d.item_code}' ";
                            await connection.ExecuteAsync(sql8);
                            string sql7 = $"insert into [dbo].[Wh_inbill_d](item_code, inbill_code, item_type, unit, buy_num, inbill_num, area_code, buy_price, product_date,create_by, create_time,zong)" +
                                $"values('{d.item_code}','{h.inbill_bh}','{d.item_type_name}','{d.unit}','0','{d.change}','{d.cw}','{d.inbill_price}',getdate(),'{d.user}',getdate(),'{d.change * d.inbill_price}')";
                            await connection.ExecuteAsync(sql7);
                        }
                    }

                    
                
                return true;
            }
        }



        public async Task<bool> Wh_sale_return_h_sale_state1Async(string sale_state, string sure_man, string sale_yj, string sr_codeId)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_return_h] set sale_state='{sale_state}',sure_man='{sure_man}',sure_date=getdate(),sale_yj='{sale_yj}' where sr_codeId='{sr_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_sale_return_h_chexiaoAsync(string sure_man, int sr_codeId)
        {

            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_sale_return_h]  set sale_state=0,sure_man='{sure_man}',sure_date=getdate() where sr_codeId='{sr_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<IEnumerable<Wh_saleReturn_dXX>> Wh_sale_return_h__srlAsyunc(string sr_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM [Wh_saleReturn_dXX] where sr_code='{sr_code}'";
                return await connection.QueryAsync<Wh_saleReturn_dXX>(sql);
            }
        }

        public async Task<IEnumerable<ST1>> Wh_sale_return_h__sr213lAsyunc(string inbill_bh)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM [dbo].[ST] where inbill_bh='{inbill_bh}'";
                return await connection.QueryAsync<ST1>(sql);
            }
        }
    }
}
