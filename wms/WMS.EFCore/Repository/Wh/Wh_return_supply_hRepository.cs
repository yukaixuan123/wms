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

namespace WMS.EFCore.Repository.Wh
{
    public class Wh_return_supply_hRepository:IWh_return_supply_hRepository
    {
        private readonly MyContext myContext;
        public Wh_return_supply_hRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }

        /// <summary>
        /// 进货退货添加
        /// </summary>
        /// <param name="sg"></param>
        /// <param name="gg"></param>
        /// <returns></returns>
        public async Task<bool> Wh_return_supply_h_InsertAsync(List<Wh_return_supply_d> dd, Wh_return_supply_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"insert into [dbo].[Wh_return_supply_h](returns_code, buy_code, sr_date, supply_code, link_man, link_way, buy_man, returns_num, returns_money, buy_price, remark, create_by,remarks)
                values('{h.returns_code}','{h.buy_code}','{h.sr_date}','{h.supply_code}','{h.link_man}','{h.link_way}','{h.buy_man}','{h.returns_num}','{h.returns_money}','{h.buy_price}','{h.remark}','{h.create_by}','{h.remarks}')";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_return_supply_d](returns_code,item_code,item_name, return_goods_num, buy_price, return_money, model_code,inbill3_num)
                        values('{h.returns_code}','{item.item_code}','{item.item_name}','{item.return_goods_num}','{item.buy_price}','{item.return_money}','{item.model_code}','{item.inbill3_num}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }


        /// <summary>
        /// 进货退货修改
        /// </summary>
        /// <param name="sg"></param>
        /// <param name="gg"></param>
        /// <returns></returns>
        public async Task<bool> Wh_return_supply_h_UpdateAsync(List<Wh_return_supply_d> dd, Wh_return_supply_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_return_supply_h] set sr_date='{h.sr_date}',remark='{h.remark}',remarks='{h.remarks}', returns_num='{h.returns_num}', returns_money='{h.returns_money}' where returns_code='{h.returns_code}'";
                bool res = await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    string sql1 = $@"delete from [dbo].[Wh_return_supply_d] where returns_code='{h.returns_code}'";
                    await connection.ExecuteAsync(sql1);
                    foreach (var item in dd)
                    {
                        string ss = $@"insert into [dbo].[Wh_return_supply_d](returns_code,item_code,item_name, return_goods_num, buy_price, return_money, model_code)
                        values('{h.returns_code}','{item.item_code}','{item.item_name}','{item.return_goods_num}','{item.buy_price}','{item.return_money}','{item.model_code}')";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }


        /// <summary>
        /// 进货退货分页查询
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<FenYeDapper<View_Return_supply>> Wh_return_supply_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "buy_codeId");
                dynamicParameters.Add("@tableName", "View_Return_supply");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeDapper<View_Return_supply> fenYe = new FenYeDapper<View_Return_supply>();
                fenYe.List = await con.QueryAsync<View_Return_supply>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }
        /// <summary>
        /// 进货退货删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_return_supply_h_DeleteAsync(int buy_codeId)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_return_supply_h] set is_del=1 where buy_codeId='{buy_codeId}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        public async Task<bool> Wh_return_supply_h_DeleteArryAsync(int[] carModel)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < carModel.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_return_supply_h] set is_del=1 where buy_codeId='{carModel[i]}'";
                    await con.ExecuteAsync(sql);
                }
                return true;
            }
        }

        /// <summary>
        /// 根据退货单号查基本信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        public async Task<View_Return_supply> Wh_return_supply_h_CodeAsyunc(string returns_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[view_Return_supply] where returns_code='{returns_code}'";
                return await connection.QueryFirstAsync<View_Return_supply>(sql);
            }
        }
        /// <summary>
        /// 根据退货单号查详细信息
        /// </summary>
        /// <param name="returns_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_return_supply_d>> Wh_return_supply_h_Code1Asyunc(string returns_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM [dbo].[Wh_return_supply_d] WHERE returns_code='{returns_code}'";
                return await connection.QueryAsync<Wh_return_supply_d>(sql);
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

        public async Task<bool> Wh_return_supply_h_sale_stateAsync(List<Wh_orderbuy_d> dd,Wh_return_supply_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_return_supply_h] set sale_state='{h.sale_state}',sure_man='{h.sure_man}',sure_date=getdate(),sure_yj='{h.sure_yj}' where buy_codeId='{h.buy_codeId}'";
                bool res= await connection.ExecuteAsync(sql) > 0 ? true : false;
                if (res)
                {
                    foreach (var item in dd)
                    {
                        string ss = $@"update [dbo].[Wh_orderbuy_d] set return_goods_num=return_goods_num+'{item.return_goods_num}' where buy_code='{item.buy_code}'  ";
                        await connection.ExecuteAsync(ss);
                    }
                }
                return true;
            }
        }

        public async Task<bool> Wh_return_supply_h_sale_state1Async(string sale_state,string sure_man,string sure_yj,string buy_codeId)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update [dbo].[Wh_return_supply_h] set sale_state='{sale_state}',sure_man='{sure_man}',sure_date=getdate(),sure_yj='{sure_yj}' where buy_codeId='{buy_codeId}'";
               return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 撤销
        /// </summary>
        /// <param name="sure_man"></param>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public async Task<bool> Wh_return_supply_h_chexiaoAsync(string sure_man, int buy_codeId)
        {

            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"update  [dbo].[Wh_return_supply_h] set sale_state=0,sure_man='{sure_man}',sure_date=getdate() where buy_codeId='{buy_codeId}'";
                return await connection.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 根据进货订单查退货记录
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public async Task<IEnumerable<Wh_return_supply_h>> Wh_return_supply_h_thjlAsyunc(string buy_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Wh_return_supply_h] where buy_code='{buy_code}'";
                return await connection.QueryAsync<Wh_return_supply_h>(sql);
            }
        }
        public async Task<IEnumerable<Wh_GoodsReturn_dXX>> Wh_return_supply_h_t213Asyunc(string returns_code)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Wh_GoodsReturn_dXX1] where returns_code='{returns_code}'";
                return await connection.QueryAsync<Wh_GoodsReturn_dXX>(sql);
            }
        }

        public async Task<bool> Wh_return_supply_h_inse123rAsync(List<Wh_GoodsReturn_dXX> dd, Wh_outbill_h h)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string bb = "";
                decimal ru = 0;
                decimal wei = 0;
                foreach (var item in dd)
                {
                    bb = item.returns_code;
                    ru += item.change;
                    wei += item.inbill3_num;
                }
                string sql2 = $"update [dbo].[Wh_return_supply_h]  set sale_state='3'  where returns_code='{h.outbill_code}'";
                await connection.ExecuteAsync(sql2);
                if (ru == wei)
                {
                    string sql3 = $"update [dbo].[Wh_return_supply_h]  set sale_state='4'  where returns_code='{h.outbill_code}'  ";
                    await connection.ExecuteAsync(sql3);
                }

                string sql11 = $@"SELECT count(0) FROM [dbo].[Wh_outbill_h] where  outbill_code='{h.outbill_code}'";
                var count = await connection.QueryFirstAsync<int>(sql11);
                if (count > 0)
                {

                    string sqlxg = $@"update [dbo].[Wh_outbill_h] set outbill_date='{h.outbill_date}',duty_man='{h.duty_man}',remark='{h.remark}',ware_code='{h.ware_code}' where outbill_code='{h.outbill_code}'";
                    await connection.ExecuteAsync(sqlxg);
                    foreach (var d in dd)
                    {

                        string sql81 = $@"update [dbo].[Wh_return_supply_d] set inbill3_num=inbill3_num-'{d.change}' where returns_code='{d.returns_code}' and item_code='{d.item_code}' ";
                        await connection.ExecuteAsync(sql81);

                        string sqlxxx = $"update  [dbo].[Wh_outbill_d] set outbill_num=outbill_num+'{d.change}',area_code='{d.cw}',zong=(outbill_num+'{d.change}')*'{d.inbill_price}' where outbill_code='{h.outbill_code}'";
                        await connection.ExecuteAsync(sqlxxx);
                    }
                }
                else
                {

                    string sql6 = $"insert into [dbo].[Wh_outbill_h](outbill_type, outbill_state, create_time,create_by,outbill_date ,ware_code,duty_man,sale_code,remark,outbill_code)values" +
                       $"('退货出库',0,getdate(),'{h.create_by}','{h.outbill_date}','{h.ware_code}','{h.duty_man}','','{h.remark}','{h.outbill_code}')";
                    await connection.ExecuteAsync(sql6);
                    foreach (var d in dd)
                    {
                        string sql81 = $@"update [dbo].[Wh_return_supply_d] set inbill3_num=inbill3_num-'{d.change}' where returns_code='{d.returns_code}' and item_code='{d.item_code}' ";
                        await connection.ExecuteAsync(sql81);


                        string sql7 = $"insert into [dbo].[Wh_outbill_d](item_code, outbill_code, item_type, unit, sale_num, outbill_num, area_code, sale_price, product_date,create_by, create_time,zong)" +
                            $"values('{d.item_code}','{h.outbill_code}','{d.item_type_name}','{d.unit}','0','{d.change}','{d.cw}','{d.inbill_price}',getdate(),'{d.user}',getdate(),'{d.change * d.inbill_price}')";
                        await connection.ExecuteAsync(sql7);
                    }
                }
                return true;
            }
        }
        public async Task<IEnumerable<ST2>> Wh_return_supply_h_sr213lAsyunc(string outbill_bh)
        {
            using (SqlConnection connection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"SELECT * FROM [dbo].[ST1] where outbill_code='{outbill_bh}'";
                return await connection.QueryAsync<ST2>(sql);
            }
        }
    } 

}
