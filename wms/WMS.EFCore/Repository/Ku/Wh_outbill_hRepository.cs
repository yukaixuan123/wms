using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Repository.Ku;
using WMS.EFCore.Migrations;

namespace WMS.EFCore.Repository.Ku
{
    /// <summary>
    /// 出库管理
    /// </summary>
    public class Wh_outbill_hRepository : IWh_outbill_hRepository
    {
        private readonly MyContext myContext;
        public Wh_outbill_hRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }
        /// <summary>
        /// 客户
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_customer>> Bs_customerFind()
        {
            return myContext.Bs_customer.Where(p => p.is_del.Contains("0")).ToListAsync();
        }
        /// <summary>
        /// 根据名字找客户
        /// </summary>
        /// <returns></returns>
        public Task<Bs_customer> Bs_customerName(string name)
        {
            return myContext.Bs_customer.FirstOrDefaultAsync(p => p.is_del.Contains("0") && p.cust_name.Equals(name));
        }

        /// <summary>
        /// 根据名字找仓库
        /// </summary>
        /// <returns></returns>
        public Task<Bs_warehouse> Bs_warehouseName(string name)
        {
            return myContext.Bs_ware.FirstOrDefaultAsync(p => p.is_del.Contains("0") && p.ware_name.Equals(name));
        }
        /// <summary>
        /// 有库存的仓库(锁定)
        /// </summary>
        /// <returns></returns>
        public async Task<List<string>> Ku(int id)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select DISTINCT w.ware_code from Wh_now_storage w inner join [dbo].[Bs_warehouse] b on w.ware_code=b.ware_name where w.is_del='0' and b.is_lock='{id}' ";
                var result = await con.QueryAsync<string>(sql);
                return result.ToList();
            }
        }
        /// <summary>
        /// 有库存的仓库
        /// </summary>
        /// <returns></returns>
        public async Task<List<string>> Ku1()
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select DISTINCT w.ware_code from Wh_now_storage w inner join [dbo].[Bs_warehouse] b on w.ware_code=b.ware_name where w.is_del='0' ";
                var result = await con.QueryAsync<string>(sql);
                return result.ToList();
            }
        }

        /// <summary>
        /// 有库存的货品
        /// </summary>
        /// <returns></returns>
        public async Task<string[]> Hp(string ck)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select DISTINCT item_code from [dbo].[Wh_now_storage] where is_del='0' and ware_code='{ck}'";
                var result = await con.QueryAsync<string>(sql);
                return result.ToArray();
            }
        }
        /// <summary>
        /// 对应货品的库存
        /// </summary>
        /// <param name="hp"></param>
        /// <param name="kw"></param>
        /// <returns></returns>
        public async Task<Wh_now_storage> Num(string hp, string kw)
        {
            try
            {
                using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
                {
                    string sql = $"select * from Wh_now_storage where is_del='0' and area_code='{kw}' and item_code='{hp}'";
                    return await con.QueryFirstAsync<Wh_now_storage>(sql);
                }
            }
            catch (Exception ex)
            {
                // 处理异常，例如记录日志或返回默认值
                Console.WriteLine($"查询发生异常: {ex.Message}");
                return null; // 或者返回你定义的默认值
            }

        }

        //详细信息
        public async Task<Wh_outbill_h> Wh_outbill_hMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"  select* from[dbo].[Wh_outbill_h] where[outbill_code] = '{bh}' and is_del = 0";
                return await con.QueryFirstAsync<Wh_outbill_h>(sql);
            }

        }

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Wh_outbill_dXX>> Wh_outbill_dMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Wh_outbill_dXX where outbill_code='{bh}'";
                List<Wh_outbill_dXX> xx = (List<Wh_outbill_dXX>)con.Query<Wh_outbill_dXX>(sql);
                List<Wh_outbill_dXX> list = new List<Wh_outbill_dXX>(); // 初始化list
                foreach (var item in xx)
                {
                    string rr1 = $"select outbill_num from Wh_sale_d d inner join Wh_outbill_h h on d.sale_code=h.sale_code where h.outbill_code='{bh}' and d.item_code='{item.item_code}'";
                    item.wei = (decimal)await con.ExecuteScalarAsync<decimal>(rr1);
                    string kk = $"select (inbill3_num-plan_outnum) as num from Wh_now_storage where is_del='0'and area_code='{item.area_code}'and item_code='{item.item_code}'\r\n";
                    item.ku = (decimal)await con.ExecuteScalarAsync<decimal>(kk);
                    list.Add(item);
                }
                return list;
            }
        }

        //销售订单分页
        public async Task<Fen<View_Sale>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str)
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
                Fen<View_Sale> fenYe = new Fen<View_Sale>();
                fenYe.List = await con.QueryAsync<View_Sale>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }
        /// <summary>
        /// 销售订单详细
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<List<Wh_sale_dXX>> Wh_sale_BH(string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from [dbo].[Wh_sale_dXX] where sale_code='{str}'";
                return (List<Wh_sale_dXX>)await con.QueryAsync<Wh_sale_dXX>(sql);
            }
            }

        //出库管理分页
        public async Task<Fen<ST11>> FenYE(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "outbill_h_id");
                dynamicParameters.Add("@tableName", "ST1");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<ST11> fenYe = new Fen<ST11>();
                fenYe.List = await con.QueryAsync<ST11>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }


        //添加出库(没有关联订单)

        public async Task<bool> Insert1Wh_outbill_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
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
                        var n4 = arrayList[3];//出库日期
                        var n5 = arrayList[4];//备注
                        var n6 = arrayList[5];//联系人
                        var n7 = arrayList[6];//联系方式
                        var n8 = arrayList[7];//关联单号
                        var n9 = arrayList[8];//客户
                        var n11 = "";
                        var n10 = "";
                        try
                        {
                            n11 = arrayList[10].ToString();//经办人
                            n10 = arrayList[9].ToString();//创建人
                        }
                        catch (Exception)
                        {
                            n10 = "";
                            n11 = "";
                        }

                        //进行增加入库基本信息表
                        string sql = $"insert into [dbo].[Wh_outbill_h](outbill_code,outbill_type, outbill_date, sale_code, cust_code, link_man, link_way, duty_man, remark, create_by, create_time,ware_code)values('{n1}','{n2}','{n4}','{n8}','{n9}','{n6}','{n7}','{n11}','{n5}','{n10}','{currentDate}','{n3}')";

                        await sqlConnection.ExecuteAsync(sql, null, transaction);



                        foreach (var item in xx)
                        {

                            //增加入库详情信息表
                            string sql1 = $"insert into [dbo].[Wh_outbill_d](outbill_code, item_code, item_type, unit, sale_num, outbill_num, area_code, sale_price, product_date,  create_by, create_time,remark,zong)values('{n1}','{item.item_code}','{n2}','{item.unit}','0','{item.change}','{item.cw}','{item.inbill_price}','{currentDate}','{n10}','{currentDate}','{item.remark11}','{item.zong}')";
                            await sqlConnection.ExecuteAsync(sql1, null, transaction);

                            //修改库存
                            string slq2 = $"update Wh_now_storage set plan_outnum=plan_outnum+'{item.change}'where is_del='0'and area_code='{item.cw}'and item_code='{item.item_code}' and ware_code='{n3}'";
                            await sqlConnection.ExecuteAsync(slq2, null, transaction);

                           
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


        //添加出库(有关联订单)

        public async Task<bool> InsertWh_outbill_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
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
                        var n4 = arrayList[3];//出库日期
                        var n5 = arrayList[4];//备注
                        var n6 = arrayList[5];//联系人
                        var n7 = arrayList[6];//联系方式
                        var n8 = arrayList[7];//关联单号
                        var n9 = arrayList[8];//客户
                        var n11 = "";
                        var n10 = "";
                        try
                        {
                            n11 = arrayList[10].ToString();//经办人
                            n10 = arrayList[9].ToString();//创建人
                        }
                        catch (Exception)
                        {
                            n10 = "";
                            n11 = "";
                        }

                        //进行增加入库基本信息表
                        string sql = $"insert into [dbo].[Wh_outbill_h](outbill_code,outbill_type, outbill_date, sale_code, cust_code, link_man, link_way, duty_man, remark, create_by, create_time,ware_code)values('{n1}','{n2}','{n4}','{n8}','{n9}','{n6}','{n7}','{n11}','{n5}','{n10}','{currentDate}','{n3}')";

                        await sqlConnection.ExecuteAsync(sql, null, transaction);



                        foreach (var item in xx)
                        {

                            //增加入库详情信息表
                            string sql1 = $"insert into [dbo].[Wh_outbill_d](outbill_code, item_code, item_type, unit, sale_num, outbill_num, area_code, sale_price, product_date,  create_by, create_time,remark,zong)values('{n1}','{item.item_code}','{n2}','{item.unit}','{item.inbill3_num}','{item.change}','{item.cw}','{item.inbill_price}','{currentDate}','{n10}','{currentDate}','{item.remark11}','{item.zong}')";
                            await sqlConnection.ExecuteAsync(sql1, null, transaction);

                            //修改库存
                            string slq2 = $"update Wh_now_storage set plan_outnum=plan_outnum+'{item.change}' where is_del='0'and area_code='{item.cw}'and item_code='{item.item_code}' and ware_code='{n3}'";
                            await sqlConnection.ExecuteAsync(slq2, null, transaction);

                    

                        }
                        string bb = "";
                        decimal ru = 0;
                        decimal wei = 0;
                        foreach (var item in xx)
                        {
                            bb = item.sale_code;
                            ru += item.change;
                            wei += item.inbill3_num - item.outbill_num;
                            string sql2 = $"UPDATE [dbo].[Wh_sale_d] SET outbill_num = outbill_num + '{item.change}' WHERE sale_code = '{item.sale_code}' AND item_code = '{item.item_code}'";
                            await sqlConnection.ExecuteAsync(sql2, null, transaction);
                        }
                        if (ru == wei)
                        {
                            string s1 = $"UPDATE [dbo].[Wh_sale_h] SET sale_state=4 where sate_code = '{bb}'";
                            await sqlConnection.ExecuteAsync(s1,null, transaction);
                        }
                        else
                        {
                            string s1 = $"UPDATE [dbo].[Wh_sale_h] SET sale_state=3 where sale_code = '{bb}'";
                            await sqlConnection.ExecuteAsync(s1, null, transaction);
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


        //修改出库(没有关联订单)

        public async Task<bool> Update1Wh_outbill_hAsync(ArrayList arrayList, List<Wh_outbill_dXX> xx)
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
                        var n1 = arrayList[0];//入库单号
                        var n2 = arrayList[1];//入库类型
                        var n3 = arrayList[2];//仓库名称
                        var n4 = arrayList[3];//入库日期
                        var n5 = arrayList[4];//备注
                        var n6 = arrayList[5];//联系人
                        var n7 = arrayList[6];//联系方式
                        var n8 = arrayList[7];//关联单号
                        var n9 = arrayList[8];//供应商
                        var zt = arrayList[10];//状态
                        var n11 = "";
                        var n10 = "";
                        try
                        {
                            n11 = arrayList[11].ToString();//经办人
                            n10 = arrayList[9].ToString();//创建人
                        }
                        catch (Exception)
                        {
                            n10 = "";
                            n11 = "";
                        }
                        int i = 1;

                        //驳回变待审核
                        if (zt.Equals("1"))
                        {
                            //进行修改入库基本信息表
                            string sql5 = $"update [dbo].[Wh_outbill_h] set outbill_state=0,sure_state=0,[sure_man]=NULL,[sure_date]=NULL where outbill_code='{n1}'";
                            await sqlConnection.ExecuteAsync(sql5,null,transaction);
                            string sql4 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('0','重新提交 ','{n10}','{n1}')";
                            await sqlConnection.ExecuteAsync(sql4, null, transaction);
                        }
                        //进行修改入库基本信息表
                        string sql = $"update [dbo].[Wh_outbill_h] set outbill_type='{n2}',  outbill_date='{n4}',  cust_code='{n9}', link_man='{n6}', link_way='{n7}', duty_man='{n10}', remark='{n5}',  update_time='{date}', update_by='{n11}', ware_code='{n3}' where outbill_code='{n1}'";
                        await sqlConnection.ExecuteAsync(sql, null, transaction);


                        
                       
                        string sql6 = $"select * from Wh_outbill_d where outbill_code='{n1}'";
                        List<Wh_outbill_d> dd = (List<Wh_outbill_d>)sqlConnection.Query<Wh_outbill_d>(sql6,null,transaction);
                      
                        foreach (var item in dd)
                        {
                            string rr1 = $"select outbill_num from Wh_outbill_d  where outbill_code='{n1}' and item_code='{item.item_code}'";
                            decimal yuan  = (decimal)await sqlConnection.ExecuteScalarAsync<decimal>(rr1,null,transaction);
                            // //删除库存
                            string rr2 = $"update Wh_now_storage set plan_outnum=plan_outnum-'{yuan}' where is_del='0'and area_code='{item.area_code}'and item_code='{item.item_code}'";
                            await sqlConnection.ExecuteAsync(rr2, null, transaction);

                        }
                        //删除原本数据
                        string sql2 = $"delete from [dbo].[Wh_outbill_d] where outbill_code='{n1}'";
                        await sqlConnection.ExecuteAsync(sql2, null, transaction);
                        foreach (var item in xx)
                        {
                            //添加入库详情信息表
                            string sql1 = $"insert into [dbo].[Wh_outbill_d](outbill_code, item_code, item_type, unit, sale_num, outbill_num, area_code, sale_price, product_date,  create_by, create_time,remark,zong)values('{n1}','{item.item_code}','{n2}','{item.unit}','{item.sale_num}','{item.outbill_num}','{item.area_code}','{item.sale_price}','{currentDate}','{n10}','{currentDate}','{item.remark}','{item.zong}')";
                            await sqlConnection.ExecuteAsync(sql1, null, transaction);
                            //添加库存信息
                            //修改库存
                            string slq2 = $"update Wh_now_storage set plan_outnum=plan_outnum+'{item.outbill_num}'where is_del='0'and area_code='{item.area_code}'and item_code='{item.item_code}' and ware_code='{n3}'";
                            await sqlConnection.ExecuteAsync(slq2, null, transaction);

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



        //修改出库(有关联订单)

        public async Task<bool> Update2Wh_outbill_hAsync(ArrayList arrayList, List<Wh_outbill_dXX> xx)
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
                        var n1 = arrayList[0];//入库单号
                        var n2 = arrayList[1];//入库类型
                        var n3 = arrayList[2];//仓库名称
                        var n4 = arrayList[3];//入库日期
                        var n5 = arrayList[4];//备注
                        var n6 = arrayList[5];//联系人
                        var n7 = arrayList[6];//联系方式
                        var n8 = arrayList[7];//关联单号
                        var n9 = arrayList[8];//供应商
                        var zt = arrayList[10];//状态
                        var n11 = "";
                        var n10 = "";
                        try
                        {
                            n11 = arrayList[11].ToString();//经办人
                            n10 = arrayList[9].ToString();//创建人
                        }
                        catch (Exception)
                        {
                            n10 = "";
                            n11 = "";
                        }

                        //驳回变待审核
                        if (zt.Equals("1"))
                        {
                            //进行修改入库基本信息表
                            string sql5 = $"update [dbo].[Wh_outbill_h] set outbill_state=0,sure_state=0,[sure_man]=NULL,[sure_date]=NULL where outbill_code='{n1}'";
                            await sqlConnection.ExecuteAsync(sql5, null, transaction);
                            string sql4 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('0','重新提交 ','{n10}','{n1}')";
                            await sqlConnection.ExecuteAsync(sql4, null, transaction);
                        }
                        //进行修改入库基本信息表
                        string sql = $"update [dbo].[Wh_outbill_h] set outbill_type='{n2}',  outbill_date='{n4}',  cust_code='{n9}', link_man='{n6}', link_way='{n7}', duty_man='{n10}', remark='{n5}',  update_time='{date}', update_by='{n11}', ware_code='{n3}' where outbill_code='{n1}'";
                        await sqlConnection.ExecuteAsync(sql, null, transaction);



                        foreach (var item in xx)
                        {
                            //修改订单的入库数量
                            //最开始的总出库数量
                            string rr1 = $"select outbill_num from [dbo].[Wh_sale_d] where sale_code='{n8}'and item_name='{item.item_name}'";
                            decimal zz = (decimal)await sqlConnection.ExecuteScalarAsync<decimal>(rr1, null, transaction);

                            //最开始的总出库库存数量
                            string rr2 = $"select plan_outnum from Wh_now_storage  where is_del='0'and area_code='{item.area_code}'and item_code='{item.item_code}'";
                            decimal z2 = (decimal)await sqlConnection.ExecuteScalarAsync<decimal>(rr2, null, transaction);

                            //原本的总出库数量
                            string rr = $"select outbill_num from [dbo].[Wh_outbill_dXX] where outbill_code='{n1}' and  item_name='{item.item_name}'";
                            decimal yuan = (decimal)await sqlConnection.ExecuteScalarAsync<decimal>(rr, null, transaction);
                            decimal nn = 0;
                            decimal ku = 0;
                            if (yuan < item.outbill_num)
                            {
                                nn = zz + (item.outbill_num - yuan);
                                ku = z2 + (item.outbill_num - yuan);
                            }
                            else if (yuan > item.outbill_num)
                            {
                                nn = zz - (yuan - item.outbill_num);
                                ku=z2-(yuan - item.outbill_num);
                            }
                            else
                             if (yuan == item.outbill_num)
                            {
                                nn = zz;
                                ku = z2;
                            }
                            string sql2 = $"UPDATE [dbo].[Wh_sale_d] SET outbill_num ='{nn}' WHERE sale_code = '{n8}' AND item_name = '{item.item_name}'";
                            await sqlConnection.ExecuteAsync(sql2, null, transaction);

                            string sql3 = $"update Wh_now_storage set plan_outnum='{ku}' WHERE  is_del='0'and area_code='{item.area_code}'and item_code='{item.item_code}'";
                            await sqlConnection.ExecuteAsync(sql3, null, transaction);
                            //修改入库详情信息表
                            string slq1 = $"update [dbo].[Wh_outbill_d] set    outbill_num='{item.outbill_num}', area_code='{item.area_code}',   update_time='{date}', update_by='{n10}', remark='{item.remark}', zong='{item.zong}'where outbill_code='{n1}'and [item_code]='{item.item_code}'";
                            await sqlConnection.ExecuteAsync(slq1, null, transaction);
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
        //删除出库信息
        public async Task<bool> DeleteWh_outbill_hAsync(string dto)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"update [dbo].[Wh_outbill_h] set is_del=1 where [outbill_code]='{dto}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
            }

        //批量删除出库信息
        public async Task<bool> DeleteSWh_outbill_hAsync(int[] sz)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                for (int i = 0; i < sz.Length; i++)
                {
                    string sql = $"update [dbo].[Wh_outbill_h] set is_del=1 where [outbill_h_id]='{sz[i]}'";
                    await con.ExecuteAsync(sql);

                }
                return true;
            }
        }

        //审核
        public async Task<bool> Wh_outbill_hSHAsync(int zt, string name, string desc, string ii)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DateTime currentDate = DateTime.Now;
                //进行获取当前日期
                string date = currentDate.ToString("yyyy-MM-dd");
                string sql1 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('{zt}','{desc}','{name}','{ii}')";
                await con.ExecuteAsync(sql1);
                if (ii.StartsWith("DB"))
                {
                    string sql2 = $"update [dbo].[Wh_transfer_h] set [outware_state]='3' where  [transfer_code]='{ii}'";
                    await con.ExecuteAsync(sql2);
                }
                string sql = $@"update[dbo].[Wh_outbill_h] set[outbill_state]='{zt}',[sure_state]='{zt}',[sure_man]='{name}',[sure_date]='{date}'where[outbill_code]='{ii}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        //改变库存
        public async Task<bool> Wh_now_storageAsync(string dh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string slq2 = $"select  d.sale_num, d.area_code,d.item_code,d.outbill_num,h.ware_code from Wh_outbill_h h inner join Wh_outbill_d d on h.outbill_code=d.outbill_code where h.outbill_code='{dh}'";
                var xx = await con.QueryAsync(slq2);
                foreach (var item in xx)
                {
                        // 更新 Wh_now_storage 表中 inbill3_num
                        string sqlUpdate = $"UPDATE [dbo].[Wh_now_storage] SET inbill3_num = inbill3_num - {item.outbill_num} ,plan_outnum=plan_outnum-{item.outbill_num} WHERE  item_code = '{item.item_code}' and area_code='{item.area_code}' and is_del=0";
                        await con.ExecuteAsync(sqlUpdate);
                   
                }
                return true;

            }
        }
    }
}
