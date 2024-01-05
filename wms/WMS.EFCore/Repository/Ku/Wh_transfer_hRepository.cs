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
    public class Wh_transfer_hRepository: IWh_transfer_hRepository
    {
        //添加盘点

        public async Task<bool> InsertWh_transfer_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
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
                        var n3 = arrayList[2];//出仓库名称
                        var n4 = arrayList[3];//结束日期
                        var n5 = arrayList[4];//备注
                        var n6 = arrayList[6];//入仓库

                        var n11 = "";
                        var n10 = arrayList[7].ToString();//创建人
                        try
                        {
                            n11 = arrayList[5].ToString();//经办人

                        }
                        catch (Exception)
                        {
                            n11 = "";

                        }

                        //进行增加调拨基本信息表
                        string sql = $"insert into [dbo].[Wh_transfer_h](transfer_code, transfer_date, out_warecode, in_warecode, sure_state, transfer_type,  create_by, create_time, remark,sure_man)values('{n1}','{n4}','{n3}','{n6}','0','{n2}','{n10}','{date}','{n5}','{n11}')";

                        await sqlConnection.ExecuteAsync(sql, null, transaction);

                        foreach (var item in xx)
                        {
                           
                         
                            //增加调拨详情信息表
                            string sql1 = $"insert into [dbo].[Wh_transfer_d](transfer_code,  item_code, model_code, unit, outarea_code, inarea_code, out_num, in_num, inbill_price, remark)values('{n1}','{item.item_code}','{item.model_code}','{item.unit}','{item.ccw}','{item.rcw}','{item.change}','{item.change}','{item.inbill_price}','{item.remark11}')";
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


        //修改调拨

        public async Task<bool> UpdateWh_transfer_hAsync(ArrayList arrayList, List<Wh_transfer_dXX> xx)
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
                        var n3 = arrayList[2];//出仓库名称
                        var n4 = arrayList[3];//结束日期
                        var n5 = arrayList[4];//备注
                        var n6 = arrayList[6];//入仓库

                        var n11 = "";
                        var n10 = arrayList[7].ToString();//创建人
                        try
                        {
                            n11 = arrayList[5].ToString();//经办人

                        }
                        catch (Exception)
                        {
                            n11 = "";

                        }

                        //进行修改调拨基本信息表
                        string sql = $"update [dbo].[Wh_transfer_h]set  transfer_date='{n4}',   transfer_type='{n2}', in_warecode='{n6}', sure_man='{n11}', remark='{n5}' where [transfer_code]='{n1}'";

                        await sqlConnection.ExecuteAsync(sql, null, transaction);

                        //进行修改调拨基本信息表
                        string sqls = $"delete from [dbo].[Wh_transfer_d] where [transfer_code]='{n1}'";

                        await sqlConnection.ExecuteAsync(sqls, null, transaction);

                        foreach (var item in xx)
                        {


                            //增加调拨详情信息表
                            string sql1 = $"insert into [dbo].[Wh_transfer_d](transfer_code,  item_code, model_code, unit, outarea_code, inarea_code, out_num, in_num, inbill_price, remark)values('{n1}','{item.item_code}','{item.model_code}','{item.unit}','{item.outarea_code}','{item.inarea_code}','{item.out_num}','{item.out_num}','{item.inbill_price}','{item.remark}')";
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


        //库存调拨分页
        public async Task<Fen<ST33>> FenYE(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "transfer_h_id");
                dynamicParameters.Add("@tableName", "ST3");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<ST33> fenYe = new Fen<ST33>();
                fenYe.List = await con.QueryAsync<ST33>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

        //详细信息
        public async Task<Wh_transfer_h> Wh_transfer_hMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"  select* from[dbo].[Wh_transfer_h] where[transfer_code] = '{bh}' and is_del = 0";
                return await con.QueryFirstAsync<Wh_transfer_h>(sql);
            }

        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Wh_transfer_dXX>> Wh_transfer_dMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Wh_transfer_dXX where transfer_code='{bh}'";
                return (List<Wh_transfer_dXX>)await con.QueryAsync<Wh_transfer_dXX>(sql);

            }
        }


        //审核
        public async Task<bool> Wh_transfer_hSHAsync(int zt, string name, string desc, string ii)
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
                        await sqlConnection.ExecuteAsync(sql1, null, transaction);
                        //修改主表的状态
                        string sql = $@"update[dbo].[Wh_transfer_h] set [sure_state]='{zt}',[sure_date]='{date}'where[transfer_code]='{ii}'";
                        await sqlConnection.ExecuteAsync(sql, null, transaction);
                        if (zt==2)
                        {
                            //更具调拨单号进行查询基本信息和详情信息
                            string sql2 = $"SELECT * FROM [dbo].[WH_transfer_h] WHERE  transfer_code  = '{ii}'";
                            var jb = await sqlConnection.QueryFirstAsync<Wh_transfer_h>(sql2, null, transaction);


                            string sql3 = $"SELECT * FROM [dbo].[WH_transfer_dXX] WHERE  transfer_code  = '{ii}'";
                            var xq = await sqlConnection.QueryAsync<Wh_transfer_dXX>(sql3, null, transaction);
                            var r = 0;
                            var c = 0;
                            foreach (Wh_transfer_dXX d in xq)
                            {
                                // 出库
                                if (r == 0)
                                {
                                    //添加出库基本信息
                                    string sql6 = $"insert into [dbo].[Wh_outbill_h](outbill_type, outbill_state, outbill_date,  create_by, create_time,ware_code,outbill_code,duty_man,sale_code)values('调拨出库',0,'{date}','{name}','{date}','{jb.out_warecode}','{ii}','{name}','')";
                                    await sqlConnection.ExecuteAsync(sql6, null, transaction);
                                    r = 1;
                                }
                                //添加出库详细信息
                                string sql9 = $"insert into [dbo].[Wh_outbill_d](outbill_code, item_code, item_type, unit, sale_num, outbill_num, area_code, sale_price, product_date,  create_by, create_time,zong)values('{ii}','{d.item_code}','{d.item_type_name}','{d.unit}','0','{d.out_num}','{d.outarea_code}','{d.inbill_price}','{currentDate}','{name}','{currentDate}','{d.out_num * d.inbill_price}')";
                                await sqlConnection.ExecuteAsync(sql9, null, transaction);

                                //修改库存
                                string slq2 = $"update Wh_now_storage set plan_outnum=plan_outnum+'{d.out_num}'where is_del='0'and area_code='{d.outarea_code}'and item_code='{d.item_code}' and ware_code='{jb.out_warecode}'";
                                await sqlConnection.ExecuteAsync(slq2, null, transaction);


                                // 入库
                                if (c == 0)
                                {
                                    //添加入库基本信息
                                    string sql6 = $"insert into [dbo].[Wh_inbill_h](inbill_type, inbill_state, inbll_date,  create_by, create_time,ware_name,inbill_bh,inbill_duty_man,buy_code)values('调拨入库',0,'{date}','{name}','{date}','{jb.in_warecode}','{ii}','{name}','')";
                                    await sqlConnection.ExecuteAsync(sql6, null, transaction);
                                    c = 1;
                                }
                                //添加入库详细信息
                                //增加入库详情信息表
                                string sql7 = $"insert into [dbo].[Wh_inbill_d](item_code, inbill_code, item_type, unit, buy_num, inbill_num, area_code, buy_price, product_date,  create_by, create_time,zong)values('{d.item_code}','{ii}','{d.item_type_name}','{d.unit}','0','{d.in_num}','{d.inarea_code}','{d.inbill_price}','{currentDate}','{name}','{currentDate}','{d.in_num * d.inbill_price}')";
                                await sqlConnection.ExecuteAsync(sql7, null, transaction);


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

        //删除调拨信息
        public async Task<bool> DeleteWh_transfer_hAsync(string dto)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_transfer_h] set is_del=1 where [transfer_code]='{dto}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        //批量删除调拨信息
        public async Task<bool> DeleteSWh_transfer_hAsync(int[] sz)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < sz.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_transfer_h] set is_del=1 where [transfer_h_id]='{sz[i]}'";
                    await con.ExecuteAsync(sql);

                }
                return true;
            }
        }
        //单位
        public async Task<List<string>> DW()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select DISTINCT unit from [dbo].[Bs_item] where is_del='0'";
                var result = await con.QueryAsync<string>(sql);
                return result.ToList();
            }
        }

        //类型
        public async Task<List<string>> LX()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select DISTINCT item_type_name from [dbo].[Bs_item_type] where is_del='0'";
                var result = await con.QueryAsync<string>(sql);
                return result.ToList();
            }
        }
        //出入库类型
        public async Task<List<string>> CRLX()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"  select DISTINCT inbill_type from LIU";
                var result = await con.QueryAsync<string>(sql);
                return result.ToList();
            }
        }
      
        //库存查询分页
        public async Task<Fen<Inventory>> KuFen(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "now_storage_id");
                dynamicParameters.Add("@tableName", "Inventory");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<Inventory> fenYe = new Fen<Inventory>();
                fenYe.List = await con.QueryAsync<Inventory>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }


        //库存流水分页
        public async Task<Fen<LIU>> LiuFen(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "inbill_code");
                dynamicParameters.Add("@tableName", "LIU");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<LIU> fenYe = new Fen<LIU>();
                fenYe.List = await con.QueryAsync<LIU>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }


        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Inventory>> KCXXAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Inventory where item_code='{bh}'";
                return (List<Inventory>)await con.QueryAsync<Inventory>(sql);

            }
        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<Inventory> KCXAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Inventory where item_code='{bh}'";
                return await con.QueryFirstAsync<Inventory>(sql);

            }
        }

    }
}
