using Dapper;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Repository.Ku;

namespace WMS.EFCore.Repository.Ku
{
    /// <summary>
    /// 库存盘点
    /// </summary>
    public class Wh_inventory_hRepository: IWh_inventory_hRepository
    {
        //添加盘点

        public async Task<bool> InsertWh_inventory_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
        {

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                await sqlConnection.OpenAsync();
                using (SqlTransaction transaction = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        DateTime currentDate = DateTime.Now;
                        //进行获取当前日期
                        string date = currentDate.ToString("yyyy-MM-dd");
                        var n1 = arrayList[0];//出库单号
                        var n2 = arrayList[1];//出库类型
                        var n3 = arrayList[2];//仓库名称
                        var n4 = arrayList[3];//结束日期
                        var n5 = arrayList[4];//备注

                        var n6 = arrayList[6];//开始日期
                        var n8 = arrayList[7];//状态
                        var n11 = "";
                        var n10 = arrayList[8].ToString();//创建人
                        try
                        {
                            n11 = arrayList[5].ToString();//经办人
                           
                        }
                        catch (Exception)
                        {
                            n11 = "";
                          
                        }

                        //进行增加盘点基本信息表
                        string sql = $"insert into [dbo].[Wh_inventory_h](inventory_code, inventory_type, ware_code, begin_date, end_date,remark,create_by,create_time,sure_man,zt)values('{n1}','{n2}','{n3}','{n6}','{n4}','{n5}','{n10}','{date}','{n11}','{n8}')";

                        await sqlConnection.ExecuteAsync(sql, null, transaction);

                        foreach (var item in xx)
                        {
                            var zt = "";
                            if (item.pdzt== "盘亏")
                            {
                                zt = "1";
                            }
                            if (item.pdzt == "盘盈")
                            {
                                zt = "2";
                            }
                            if (item.pdzt == "未盈亏")
                            {
                                zt = "0";
                            }
                            //增加入库详情信息表
                            string sql1 = $"insert into [dbo].[Wh_inventory_d](inventory_code, item_code, model_code, unit, item_type, account_num, area_code, inventory_num, break_even_num, inventory_state, inbill_price, remark)values('{n1}','{item.item_code}','{item.model_code}','{item.unit}','{item.item_type_name}','{item.zm}','{item.cw}','{item.change}','{item.yksl}','{zt}','{item.inbill_price}','{item.remark11}')";
                            await sqlConnection.ExecuteAsync(sql1, null, transaction); 

                        }
                       
                        // 如果所有语句执行成功，提交事务
                        transaction.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        // 发生错误，回滚事务
                        transaction.Rollback();
                        // 根据需要记录或处理异常
                        return false;
                    }

                }

            }
        }

        //修改盘点

        public async Task<bool> UpdateWh_inventory_hAsync(ArrayList arrayList, List<Wh_inventory_dXX> xx)
        {

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                await sqlConnection.OpenAsync();
                using (SqlTransaction transaction = sqlConnection.BeginTransaction())
                {
                    try
                    {
                        DateTime currentDate = DateTime.Now;
                        //进行获取当前日期
                        string date = currentDate.ToString("yyyy-MM-dd");
                        var n1 = arrayList[0];//出库单号
                        var n2 = arrayList[1];//出库类型
                        var n3 = arrayList[2];//仓库名称
                        var n4 = arrayList[3];//结束日期
                        var n5 = arrayList[4];//备注

                        var n6 = arrayList[6];//开始日期
                        var n8 = arrayList[7];//状态
                        var n11 = "";
                        var n10 = arrayList[8].ToString();//创建人
                        try
                        {
                            n11 = arrayList[5].ToString();//经办人

                        }
                        catch (Exception)
                        {
                            n11 = "";

                        }

                        //进行修改盘点基本信息表
                        string sql = $"update [dbo].[Wh_inventory_h] set  inventory_type='{n2}', ware_code='{n3}', begin_date='{n6}', end_date='{n4}', sure_man='{n11}', remark='{n5}',  zt='{n8}' where inventory_code='{n1}'";

                        await sqlConnection.ExecuteAsync(sql, null, transaction);

                        //删除原本的入库详细
                        string sql2 = $"delete from Wh_inventory_d where inventory_code='{n1}'";
                        await sqlConnection.ExecuteAsync(sql2, null, transaction);
                        foreach (var item in xx)
                        {
                            var zt = "";
                            if (item.pdzt == "盘亏")
                            {
                                zt = "1";
                            }
                            if (item.pdzt == "盘盈")
                            {
                                zt = "2";
                            }
                            if (item.pdzt == "未盈亏")
                            {
                                zt = "0";
                            }

                            //增加入库详情信息表
                            string sql1 = $"insert into [dbo].[Wh_inventory_d](inventory_code, item_code, model_code, unit, item_type, account_num, area_code, inventory_num, break_even_num, inventory_state, inbill_price, remark)values('{n1}','{item.item_code}','{item.model_code}','{item.unit}','{item.item_type_name}','{item.zm}','{item.area_code}','{item.inventory_num}','{item.yksl}','{zt}','{item.inbill_price}','{item.remark}')";
                            await sqlConnection.ExecuteAsync(sql1, null, transaction);

                        }

                        // 如果所有语句执行成功，提交事务
                        transaction.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        // 发生错误，回滚事务
                        transaction.Rollback();
                        // 根据需要记录或处理异常
                        return false;
                    }

                }

            }
        }

        //库存盘点分页
        public async Task<Fen<ST22>> FenYE(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "inventory_h_id");
                dynamicParameters.Add("@tableName", "ST2");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<ST22> fenYe = new Fen<ST22>();
                fenYe.List = await con.QueryAsync<ST22>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

        //审核
        public async Task<bool> Wh_inventory_hSHAsync(int zt, string name, string desc, string ii)
        {

       
            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                await sqlConnection.OpenAsync();
                using (SqlTransaction transaction = sqlConnection.BeginTransaction())
                {
                    try
                    {

                        DateTime currentDate = DateTime.Now;
                        //进行获取当前日期
                        string date = currentDate.ToString("yyyy-MM-dd");
                        //添加的审核记录表
                        string sql1 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('{zt}','{desc}','{name}','{ii}')";
                        await sqlConnection.ExecuteAsync(sql1,null,transaction);
                        //修改主表的状态
                        string sql = $@"update[dbo].[Wh_inventory_h] set [sure_state]='{zt}',[sure_date]='{date}'where[inventory_code]='{ii}'";
                         await sqlConnection.ExecuteAsync(sql,null,transaction);

                        if (zt==2)
                        {

                      
                        //更具调拨单号进行查询基本信息和详情信息
                        string sql2 = $"SELECT * FROM [dbo].[WH_inventory_h] WHERE  inventory_code  = '{ii}'";
                        var jb = await sqlConnection.QueryFirstAsync<Wh_inventory_h>(sql2, null, transaction);
                       

                        string sql3 = $"SELECT * FROM [dbo].[WH_inventory_d] WHERE  inventory_code  = '{ii}'";
                        var xq = await sqlConnection.QueryAsync<Wh_inventory_d>(sql3, null, transaction);
                        var r = 0;
                        var c = 0;
                        foreach (Wh_inventory_d d in xq)
                        {
                            if (d.inventory_state=="0")
                            {
                                //不改变
                            }
                            if (d.inventory_state == "1")
                            {
                               
                                //盘亏 出库
                                if (r == 0)
                                {
                                    //添加出库基本信息
                                    string sql6 = $"insert into [dbo].[Wh_outbill_h](outbill_type, outbill_state, outbill_date,  create_by, create_time,ware_code,outbill_code,duty_man,sale_code)values('盘点出库',0,'{date}','{name}','{date}','{jb.ware_code}','{ii}','{name}','')";
                                    await sqlConnection.ExecuteAsync(sql6, null, transaction);
                                    r = 1;
                                }
                                //添加出库详细信息
                                string sql9 = $"insert into [dbo].[Wh_outbill_d](outbill_code, item_code, item_type, unit, sale_num, outbill_num, area_code, sale_price, product_date,  create_by, create_time,zong)values('{ii}','{d.item_code}','{d.item_type}','{d.unit}','0','{d.inventory_num}','{d.area_code}','{d.inbill_price}','{currentDate}','{name}','{currentDate}','{d.inventory_num * d.inbill_price}')";
                                await sqlConnection.ExecuteAsync(sql9, null, transaction);

                                    //修改库存
                                    string slq2 = $"update Wh_now_storage set plan_outnum=plan_outnum+'{d.inventory_num}'where is_del='0'and area_code='{d.area_code}'and item_code='{d.item_code}' and ware_code='{jb.ware_code}'";
                                    await sqlConnection.ExecuteAsync(slq2, null, transaction);

                                }
                            if (d.inventory_state == "2")
                            {
                               
                                //盘盈 入库
                                if (c == 0)
                                {
                                    //添加入库基本信息
                                    string sql6 = $"insert into [dbo].[Wh_inbill_h](inbill_type, inbill_state, inbll_date,  create_by, create_time,ware_name,inbill_bh,inbill_duty_man,buy_code)values('盘点入库',0,'{date}','{name}','{date}','{jb.ware_code}','{ii}','{name}','')";
                                    await sqlConnection.ExecuteAsync(sql6, null, transaction);
                                    c = 1;
                                }
                                //添加入库详细信息
                                //增加入库详情信息表
                                string sql7 = $"insert into [dbo].[Wh_inbill_d](item_code, inbill_code, item_type, unit, buy_num, inbill_num, area_code, buy_price, product_date,  create_by, create_time,zong)values('{d.item_code}','{ii}','{d.item_type}','{d.unit}','0','{d.inventory_num}','{d.area_code}','{d.inbill_price}','{currentDate}','{name}','{currentDate}','{d.inventory_num*d.inbill_price}')";
                                await sqlConnection.ExecuteAsync(sql7,null,transaction);

                            }
                        }
                        }

                        // 如果所有语句执行成功，提交事务
                        transaction.Commit();
                        return true;
                    }
                    catch (Exception ex)
                    {
                        // 发生错误，回滚事务
                        transaction.Rollback();
                        // 根据需要记录或处理异常
                        return false;
                    }

                }

            }
        }
        //详细信息
        public async Task<Wh_inventory_h> Wh_inventory_hMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"  select* from[dbo].[Wh_inventory_h] where[inventory_code] = '{bh}' and is_del = 0";
                return await con.QueryFirstAsync<Wh_inventory_h>(sql);
            }

        }

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Wh_inventory_dXX>> Wh_inventory_dMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Wh_inventory_dXX where inventory_code='{bh}'";
                return (List<Wh_inventory_dXX>)await con.QueryAsync<Wh_inventory_dXX>(sql);
               
            }
        }

        //删除调拨信息
        public async Task<bool> DeleteWh_inventory_hAsync(string dto)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_inventory_h] set is_del=1 where [inventory_code]='{dto}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        //批量删除调拨信息
        public async Task<bool> DeleteSWh_inventory_hAsync(int[] sz)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < sz.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_inventory_h] set is_del=1 where [inventory_h_id]='{sz[i]}'";
                    await con.ExecuteAsync(sql);

                }
                return true;
            }
        }
    }
}
