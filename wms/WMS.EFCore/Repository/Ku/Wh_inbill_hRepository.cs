using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Reflection.Metadata;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Ku;
using WMS.EFCore.Migrations;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

namespace WMS.EFCore.Repository.Ku
{
    public class Wh_inbill_hRepository : IWh_inbill_hRepository
    {
        private readonly MyContext myContext;
        public Wh_inbill_hRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }
        //查询全部
        public Task<List<Wh_inbill_h>> Wh_inbill_hSelectAsync()
        {
            return myContext.Wh_hh.ToListAsync();
        }
        //分页
        public IEnumerable<Wh_inbill_h> Wh_inbill_hFenYeAsync(int page, int pageSize)
        {
            return myContext.Wh_hh.Skip((page - 1) * pageSize).Take(pageSize).ToList();
        }
        //模糊查询
        public async Task<Wh_inbill_h> Wh_inbill_hMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"  select* from[dbo].[Wh_inbill_h] where[inbill_bh] = '{bh}' and is_del = 0";
                return await con.QueryFirstAsync<Wh_inbill_h>(sql);
            }
          
        }

        public  async Task<List<Wh_inbill_dXX>> Wh_inbill_dMHAsync(string bh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $"select * from Wh_inbill_dXX where inbill_code='{bh}'";
                List<Wh_inbill_dXX> xx = (List<Wh_inbill_dXX>)con.Query<Wh_inbill_dXX>(sql);
                List<Wh_inbill_dXX> list = new List<Wh_inbill_dXX>(); // 初始化list
                foreach (var item in xx)
                {
                    string rr1 = $"select inbill_num from [Wh_orderbuy_d] d inner join Wh_inbill_h h on d.buy_code=h.buy_code where h.inbill_bh='{bh}' and d.item_name='{item.item_name}'";
                    decimal zz = (decimal)await con.ExecuteScalarAsync<decimal>(rr1);
                    item.wei = zz;
                    list.Add(item);
                }
                return list;
                }
        }
        //分页模糊查询
        public async Task<FenYe<Wh_inbill_h>> Wh_inbill_hAsync(int page, int pageSize, string bh, string lx, string zt, string ck)
        {
            if (page == 0) { page = 1; }

            
            //var query = myContext.st.FromSqlRaw("SELECT * FROM ST").AsQueryable();
            var query = myContext.Wh_hh.AsQueryable();
            
            Console.WriteLine(query.ToList());

            
            //query = query.Where(p => p.is_del.Contains("0"));

            if (!string.IsNullOrEmpty(bh))
            {
                query = query.Where(p => p.buy_code.Contains(bh));
            }
            if (!string.IsNullOrEmpty(lx))
            {
                query = query.Where(p => p.buy_code.Contains(lx));
            }
            if (!string.IsNullOrEmpty(zt))
            {
                query = query.Where(p => p.buy_code.Contains(zt));
            }
            if (!string.IsNullOrEmpty(ck))
            {
                query = query.Where(p => p.buy_code.Contains(ck));
            }

            var totalCount = await query.CountAsync();

            List<Wh_inbill_h> products = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();
            

            return new FenYe<Wh_inbill_h>(products, totalCount, page, pageSize);
        }
        //添加入库信息
        public async Task<bool> AddWh_inbill_hAsync(Wh_inbill_h dto)
        {
           
            myContext.Wh_hh.Add(dto);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        //修改入库信息
        public async Task<bool> UpdateWh_inbill_hAsync(Wh_inbill_h dto)
        {
            myContext.Wh_hh.Update(dto);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        //删除入库信息
        public async Task<bool> DeleteWh_inbill_hAsync(int dto)
        {
            var entity = myContext.Wh_hh.Find(dto);
                entity.is_del = "1";
            myContext.Wh_hh.Update(entity);
            return await myContext.SaveChangesAsync() >0 ? true : false;
        }


        //入库管理分页
        public async Task<Fen<ST>> FenYE(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "inbill_code");
                dynamicParameters.Add("@tableName", "ST");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<ST> fenYe = new Fen<ST>();
                fenYe.List = await con.QueryAsync<ST>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

        //货品分页
        public async Task<Fen<Bb_view>> HP(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "item_id");
                dynamicParameters.Add("@tableName", "Bb_view");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<Bb_view> fenYe = new Fen<Bb_view>();
                fenYe.List = await con.QueryAsync<Bb_view>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }
        //进货订单分页
        public async Task<Fen<View>> Wh_buy_order_hFenYeAsync(int pageSize, int currentPage, string str)
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
                Fen<View> fenYe = new Fen<View>();
                fenYe.List = await con.QueryAsync<View>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }
       
        
        /// <summary>
        /// 用户
        /// </summary>
        /// <returns></returns>
        public Task<List<Users>> UserFind()
        {
            return myContext.Users_Users.Where(p => p.is_del.Contains("0")).ToListAsync();
        }

        /// <summary>
        /// 供应商
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_supply>> Bs_supplyFind()
        {
            return myContext.Bs_supply.Where(p => p.is_del.Contains("0")).ToListAsync();
        }

        /// <summary>
        /// 根据名字找供应商
        /// </summary>
        /// <returns></returns>
        public  Task<Bs_supply> Bs_supplyName(string name)
        {
            return  myContext.Bs_supply.FirstOrDefaultAsync(p => p.is_del.Contains("0")&&p.supply_name.Equals(name));
        }

        /// <summary>
        /// 仓位
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_ware_area>> Bs_ware_areaName( string id)
        {
            return myContext.bs_wa.Where(p => p.is_del.Contains("0")&&p.warehouse_id.Equals(id)).ToListAsync();
        }

        /// <summary>
        /// 订单详细分页
        /// </summary>
        /// <returns></returns>
        public async Task<Fen<Wh_orderbuy_dXX>> Wh_orderbuy_dBH(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "item_name");
                dynamicParameters.Add("@tableName", "Wh_orderbuy_dXX");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<Wh_orderbuy_dXX> fenYe = new Fen<Wh_orderbuy_dXX>();
                fenYe.List = await con.QueryAsync<Wh_orderbuy_dXX>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
            }

        //批量删除入库信息
        public async Task<bool> DeleteSWh_inbill_hAsync(int[] sz)
        {
            for (int i = 0; i < sz.Length; i++)
            {
                var entity = myContext.Wh_hh.Find(sz[i]);
                entity.is_del = "1";
                myContext.Wh_hh.Update(entity);
                await myContext.SaveChangesAsync();
            }
            return true;
           
        }

        //添加入库(有关联订单)

        public  async Task<bool> InsertWh_inbill_hAsync(ArrayList arrayList, List<Wh_orderbuy_dXX> xx)
        {

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
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
                var n11 = "";
                var n10 = "";
                try
                {
                    n10 = arrayList[9].ToString();//创建人
                    n11 = arrayList[10].ToString();//经办人
                }
                catch (Exception)
                {
                    n10 = "";
                    n11 = "";
                }
                int i = 1;
                try
                {
                    //进行增加入库基本信息表
                    string sql = $"insert into [dbo].[Wh_inbill_h](inbill_type, inbill_state, inbll_date, buy_code, supply_code, link_man, link_way, inbill_duty_man, remark, create_by, create_time,ware_name,inbill_bh)values('{n2}',0,'{n4}','{n8}','{n9}','{n6}','{n7}','{n11}','{n5}','{n10}','{currentDate}','{n3}','{n1}')";
                    await sqlConnection.ExecuteAsync(sql);
            }
                catch (Exception)
                {
                i = 0;
            }

            try
                {
                   
                    foreach (var item in xx)
                    {
                       
                        //增加入库详情信息表
                        string sql1 = $"insert into [dbo].[Wh_inbill_d](item_code, inbill_code, item_type, unit, buy_num, inbill_num, area_code, buy_price, product_date,  create_by, create_time,remark,zong)values('{item.item_code}','{n1}','{n2}','{item.unit}','{item.buy_num}','{item.change}','{item.cw}','{item.inbill_price}','{currentDate}','{n10}','{currentDate}','{item.remark11}','{item.zong}')";
                        await sqlConnection.ExecuteAsync(sql1);
                    }
                }
                catch (Exception)
                {
                    i = 0;
                }
                try
                {
                  
                    string bb = "";
                    decimal ru = 0;
                    decimal wei = 0;
                    foreach (var item in xx)
                    {
                        bb = item.buy_code;
                        ru += item.change;
                        wei += item.buy_num - item.inbill_num;
                        string sql2 = $"UPDATE [dbo].[WH_orderbuy_d] SET inbill_num = inbill_num + '{item.change}' WHERE buy_code = '{item.buy_code}' AND item_name = '{item.item_name}'";
                        await sqlConnection.ExecuteAsync(sql2);
                    }
                    if (ru==wei)
                    {
                        string s1 = $"UPDATE [dbo].[Wh_buy_order_h] SET sale_state=4 where buy_code = '{bb}'";
                        await sqlConnection.ExecuteAsync(s1);
                    }
                    else
                    {
                        string s11 = $"UPDATE [dbo].[Wh_buy_order_h] SET sale_state=3 where buy_code = '{bb}'";
                        await sqlConnection.ExecuteAsync(s11);
                    }
                }
                catch (Exception)
                {
                    i = 0;
                }
                if (i == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }


        }


        //添加入库(没有关联订单)

        public async Task<bool> Insert1Wh_inbill_hAsync(ArrayList arrayList, List<Wh_orderbuy_dXX> xx)
        {

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
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
                int i = 1;
                try
                {
                    //进行增加入库基本信息表
                    string sql = $"insert into [dbo].[Wh_inbill_h](inbill_type, inbill_state, inbll_date, buy_code, supply_code, link_man, link_way, inbill_duty_man, remark, create_by, create_time,ware_name,inbill_bh)values('{n2}',0,'{n4}','{n8}','{n9}','{n6}','{n7}','{n11}','{n5}','{n10}','{currentDate}','{n3}','{n1}')";
                    await sqlConnection.ExecuteAsync(sql);
                }
                catch (Exception)
                {
                    i = 0;
                }

                try
                {
                    foreach (var item in xx)
                    {
                       
                        //增加入库详情信息表
                        string sql1 = $"insert into [dbo].[Wh_inbill_d](item_code, inbill_code, item_type, unit, buy_num, inbill_num, area_code, buy_price, product_date,  create_by, create_time,remark,zong)values('{item.item_code}','{n1}','{n2}','{item.unit}','0','{item.change}','{item.cw}','{item.inbill_price}','{currentDate}','{n10}','{currentDate}','{item.remark11}','{item.zong}')";
                        await sqlConnection.ExecuteAsync(sql1);
                    }
                }
                catch (Exception)
                {
                    i = 0;
                }
               
                if (i == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }


        }


        //修改入库(没有关联订单)

        public async Task<bool> Update1Wh_inbill_hAsync(ArrayList arrayList, List<Wh_inbill_dXX> xx)
        {

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
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
                var zt= arrayList[10];//状态
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
                try
                {
                    //驳回变待审核
                    if (zt.Equals("1"))
                    {
                        //进行修改入库基本信息表
                        string sql5 = $"update [dbo].[Wh_inbill_h] set inbill_state=0,sure_state=0,[sure_man]=NULL,[sure_date]=NULL where inbill_bh='{n1}'";
                        await sqlConnection.ExecuteAsync(sql5);
                        string sql4 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('0','重新提交 ','{n10}','{n1}')";
                        await sqlConnection.ExecuteAsync(sql4);
                    }
                    //进行修改入库基本信息表
                    string sql = $"update [dbo].[Wh_inbill_h] set inbill_type='{n2}',  inbll_date='{n4}',  supply_code='{n9}', link_man='{n6}', link_way='{n7}', inbill_duty_man='{n10}', remark='{n5}',  update_time='{date}', update_by='{n11}', ware_name='{n3}' where inbill_bh='{n1}'";
                    await sqlConnection.ExecuteAsync(sql);
                }
                catch (Exception)
                {
                    i = 0;
                }

                try
                {
                    //删除原本数据
                    string sql2 = $"delete from [dbo].[Wh_inbill_d] where inbill_code='{n1}'";
                    await sqlConnection.ExecuteAsync(sql2);
                    foreach (var item in xx)
                    {
                        //添加入库详情信息表
                     string sql1=$" insert into[dbo].[Wh_inbill_d] (item_code, inbill_code, item_type, unit, buy_num, inbill_num, area_code, buy_price, product_date, create_by, create_time, remark, zong, update_time, update_by) values('{item.item_code}','{n1}','{n2}','{item.unit}','{item.buy_num}','{item.inbill_num}','{item.area_code}','{item.buy_price}','{currentDate}','{n10}','{currentDate}','{item.remark}','{item.zong}','{date}','{n10}')";


                        await sqlConnection.ExecuteAsync(sql1);
                    }
                }
                catch (Exception)
                {
                    i = 0;
                }

                if (i == 1)
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }


        }


        //修改入库(有关联订单)

        public async Task<bool> Update2Wh_inbill_hAsync(ArrayList arrayList, List<Wh_inbill_dXX> xx)
        {

            using (SqlConnection sqlConnection = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                await sqlConnection.OpenAsync();
                using (SqlTransaction transaction = sqlConnection.BeginTransaction())
                {

                    try {


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
                            string sql5 = $"update [dbo].[Wh_inbill_h] set inbill_state=0,sure_state=0,[sure_man]=NULL,[sure_date]=NULL where inbill_bh='{n1}'";
                            await sqlConnection.ExecuteAsync(sql5, null, transaction);
                            string sql4 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('0','重新提交 ','{n10}','{n1}')";
                            await sqlConnection.ExecuteAsync(sql4, null, transaction);
                        }
                        //进行修改入库基本信息表
                        string sql = $"update [dbo].[Wh_inbill_h] set inbill_type='{n2}',  inbll_date='{n4}',  supply_code='{n9}', link_man='{n6}', link_way='{n7}', inbill_duty_man='{n10}', remark='{n5}',  update_time='{date}', update_by='{n11}', ware_name='{n3}' where inbill_bh='{n1}'";
                        await sqlConnection.ExecuteAsync(sql, null, transaction);



                        foreach (var item in xx)
                        {
                            //修改订单的入库数量
                            //最开始的总入库数量
                            string rr1 = $"select inbill_num from [dbo].[Wh_orderbuy_d] where buy_code='{n8}'and item_name='{item.item_name}'";
                            decimal zz = (decimal)await sqlConnection.ExecuteScalarAsync<decimal>(rr1,null,transaction);
                            //原本的总入库数量
                            string rr = $"select inbill_num from [dbo].[Wh_inbill_dXX] where inbill_code='{n1}' and  item_name='{item.item_name}'";
                            decimal yuan = (decimal)await sqlConnection.ExecuteScalarAsync<decimal>(rr,null,transaction);
                            decimal nn = 0;
                            if (yuan<item.inbill_num)
                            {
                                 nn = zz + (item.inbill_num-yuan);
                               
                            }
                           else if (yuan>item.inbill_num)
                            {
                                nn = zz - (yuan- item.inbill_num );
                               
                            }else
                            if (yuan==item.inbill_num)
                            {
                                nn = zz;
                            }
                            string sql2 = $"UPDATE [dbo].[WH_orderbuy_d] SET inbill_num ='{nn}' WHERE buy_code = '{n8}' AND item_name = '{item.item_name}'";
                            await sqlConnection.ExecuteAsync(sql2, null, transaction);
                            //修改入库详情信息表
                            string slq1 = $"update [dbo].[Wh_inbill_d] set    inbill_num='{item.inbill_num}', area_code='{item.area_code}',   update_time='{date}', update_by='{n10}', remark='{item.remark}', zong='{item.zong}'where inbill_code='{n1}'and [item_code]='{item.item_code}'";
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

        //当前用户
        public async Task<Users> UsersID(string username, string password)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string sql = $@"SELECT * FROM [dbo].[Users] Where U_name='{username}' and U_password='{password}'";
                return await con.QueryFirstOrDefaultAsync<Users>(sql);
            }
        }
        //审核
        public async Task<bool> Wh_inbill_hSHAsync(int zt,string name,int id, string desc,string ii)
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
                    string sql2 = $"update [dbo].[Wh_transfer_h] set [inware_state]='1' where  [transfer_code]='{ii}'";
                    await con.ExecuteAsync(sql2);
                }
                string sql = $@"update[dbo].[Wh_inbill_h] set[inbill_state]='{zt}',[sure_state]='{zt}',[sure_man]='{name}',[sure_date]='{date}'where[inbill_code]='{id}'";
                return await con.ExecuteAsync(sql)>0?true:false;
            }
        }

        //撤销
        public async Task<bool> Wh_inbill_hCXAsync(string name,string ii)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                //添加记录
                string sql1 = $"insert into [dbo].[Audit](AuditResults, Opinions, AuditUser,AuditDH)values('3','撤销','{name}','{ii}')";
                await con.ExecuteAsync(sql1);
               
                //撤销库存
                string slq2 = $"SELECT d.inbill_num, ware_name,d.area_code,d.item_code,d.inbill_num\r\n FROM [dbo].[WH_inbill_h] h INNER JOIN [dbo].[WH_inbill_d] d ON h.inbill_bh = d.inbill_code where h.inbill_bh='{ii}'";
                var xx = await con.QueryAsync(slq2);
                foreach (var item in xx)
                {
                    // 查询 Wh_now_storage 表中是否存在记录
                    string sqlCheck = $"SELECT * FROM [dbo].[Wh_now_storage] WHERE ware_code = '{item.ware_name}' AND area_code = '{item.area_code}' AND item_code = '{item.item_code}'";
                    Wh_now_storage ww = con.QueryFirst<Wh_now_storage>(sqlCheck);

                    if (ww.inbill3_num> item.inbill_num)
                    {
                        // 更新 Wh_now_storage 表中 inbill3_num
                        string sqlUpdate = $"UPDATE [dbo].[Wh_now_storage] SET inbill3_num = inbill3_num - {item.inbill_num} WHERE ware_code = '{item.ware_name}' AND area_code = '{item.area_code}' AND item_code = '{item.item_code}' and ware_code='{item.ware_name}' and is_del=0";
                        await con.ExecuteAsync(sqlUpdate);
                    }
                    else
                    {
                        // 删除 Wh_now_storage 表中新的记录
                        string sqlInsert = $"update Wh_now_storage set is_del=1 WHERE ware_code = '{item.ware_name}' AND area_code = '{item.area_code}' AND item_code = '{item.item_code}' and ware_code='{item.ware_name}' ";
                        await con.ExecuteAsync(sqlInsert);
                    }
                }

                //更改状态
                string sql = $@"update[dbo].[Wh_inbill_h] set[inbill_state]='0',[sure_state]='0',[sure_man]=NULL,[sure_date]=NULL where[inbill_bh]='{ii}'";
               return await con.ExecuteAsync(sql)>0?true:false;

            }
        }

        //添加库存
        public async Task<bool> Wh_now_storageAsync(string dh)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                string slq2 = $"SELECT d.inbill_num, ware_name,d.area_code,d.item_code,d.inbill_num\r\n FROM [dbo].[WH_inbill_h] h INNER JOIN [dbo].[WH_inbill_d] d ON h.inbill_bh = d.inbill_code where h.inbill_bh='{dh}'";
                var xx = await con.QueryAsync(slq2);
                foreach (var item in xx)
                {
                    // 查询 Wh_now_storage 表中是否存在记录
                    string sqlCheck = $"SELECT COUNT(*) FROM [dbo].[Wh_now_storage] WHERE ware_code = '{item.ware_name}' AND area_code = '{item.area_code}' AND item_code = '{item.item_code}' and is_del=0";
                    int count = await con.ExecuteScalarAsync<int>(sqlCheck);

                    if (count > 0)
                    {
                        // 更新 Wh_now_storage 表中 inbill3_num
                        string sqlUpdate = $"UPDATE [dbo].[Wh_now_storage] SET inbill3_num = inbill3_num + {item.inbill_num} WHERE ware_code = '{item.ware_name}' AND area_code = '{item.area_code}' AND item_code = '{item.item_code}' and ware_code='{item.ware_name}' and is_del=0";
                        await con.ExecuteAsync(sqlUpdate);
                    }
                    else
                    {
                        // 插入 Wh_now_storage 表中新的记录
                        string sqlInsert = $"INSERT INTO [dbo].[Wh_now_storage] (ware_code, area_code, item_code, inbill3_num, plan_outnum) VALUES ('{item.ware_name}', '{item.area_code}', '{item.item_code}', '{item.inbill_num}', 0)";
                        await con.ExecuteAsync(sqlInsert);
                    }
                }
                return true;

            }
        }
        /// <summary>
        /// 审核记录的分页
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<Fen<Audit>> AuditFenYeAsync(int pageSize, int currentPage, string str)
        {
            using (SqlConnection con = new SqlConnection("Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;"))
            {
                DynamicParameters dynamicParameters = new DynamicParameters();
                dynamicParameters.Add("@pageSize", pageSize);
                dynamicParameters.Add("@keyName", "AuditID");
                dynamicParameters.Add("@tableName", "Audit");
                dynamicParameters.Add("@currentPage", currentPage);
                dynamicParameters.Add("@where", str);
                dynamicParameters.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                Fen<Audit> fenYe = new Fen<Audit>();
                fenYe.List = await con.QueryAsync<Audit>(sql, dynamicParameters);
                fenYe.Rows = dynamicParameters.Get<int>("rows");
                return fenYe;
            }
        }

    }
}
