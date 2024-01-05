using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity;
using WMS.Domain.Repository.Bs;
using Dapper;
using System.Data;
using System.Data.SqlClient;
using WMS.Domain.Entity.Sup;

namespace WMS.EFCore.Repository.Bs
{
    public class Bs_warehouseRepository: IBs_warehouseRepository
    {
        private readonly MyContext myContext;
        public Bs_warehouseRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }

        public async Task<bool> Bs_warehouseAdd(Bs_warehouse bs_Warehouse)
        {
            myContext.Bs_ware.Add(bs_Warehouse);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        public async Task<int> Bs_warehouseDel(Bs_warehouse bs_Warehouse)
        {
            myContext.Bs_ware.Remove(bs_Warehouse);
            return await myContext.SaveChangesAsync();
        }
        /// <summary>
        /// 没有锁的仓库
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_warehouse>> Bs_warehouseSelect()
        {
            return myContext.Bs_ware.Where(p => p.is_del.Contains("0")&&p.is_lock.Equals(0)).ToListAsync();
        }
        /// <summary>
        /// 所有的仓库
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_warehouse>> Bs_warehouseSelect1()
        {
            return myContext.Bs_ware.Where(p => p.is_del.Contains("0") ).ToListAsync();
        }

        public async Task<bool> Bs_warehouseUpdate(Bs_warehouse bs_Warehouse)
        {
            myContext.Bs_ware.Update(bs_Warehouse);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        //分页
        public IEnumerable<Bs_warehouse> Bs_warehouseFenYe(int page, int size)
        {
            return myContext.Bs_ware.Skip((page - 1) * size).Take(size).ToList();
        }

        public IEnumerable<Bs_warehouse> Bs_WarehousesMH(string bh, string zt, string zg)
        {
            var products = myContext.Bs_ware.Where(p => p.ware_code.Contains(bh) || p.ware_state.Contains(zt)
            || p.ware_duty_man.Contains(zg)).ToList();
            return products;
        }

        //分页模糊查询
        
        public FenYe<Bs_warehouse> Bs_WarehouseFYMH(int page, int size, string bh, string zt, string zg)
        {
            if(page == 0){ page= 1; }
            var query = myContext.Bs_ware.AsQueryable();
            query = query.Where(p => p.is_del.Contains("0"));

            if (!string.IsNullOrEmpty(bh))
            {
                query = query.Where(p => p.ware_code.Contains(bh));
            }
            if (!string.IsNullOrEmpty(zt))
            {
                query = query.Where(p => p.ware_state.Contains(zt));
            }
            if (!string.IsNullOrEmpty(zg))
            {
                query = query.Where(p => p.ware_duty_man.Contains(zg));
            }


            var totalCount = query.Count();

            var products = query
                .Skip((page - 1) * size)
                .Take(size)
                .ToList();

            return new FenYe<Bs_warehouse>(products, totalCount, page, size);
        }

        //删除入库信息
        public async Task<bool> Bs_WarehouseRKDel(int id,string del)
        {
            var entity=myContext.Bs_ware.Find(id);
            entity.is_del = del;
            myContext.Bs_ware.Update(entity);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }


        string constr = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";

        /// <summary>
        /// 仓库管理逻辑删除
        /// </summary>
        /// <param name="id"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<bool> DeleteHouseAsync(int id, string str)
        {
            var ee = myContext.bs_Warehouses.Find(id);
            ee.is_del = str;
            myContext.bs_Warehouses.Update(ee);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        /// <summary>
        /// 仓库管理分页查询
        /// </summary>
        /// <param name="currentPage"></param>
        /// <param name="pageSize"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        public async Task<FenYeSupply<CKView>> FenYeHouseAsync(int currentPage, int pageSize, string str)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                DynamicParameters dd = new DynamicParameters();
                dd.Add("@pageSize", pageSize);
                dd.Add("@keyName", "warehouse_id");
                dd.Add("@tableName", "CKView");
                dd.Add("@currentPage", currentPage);
                dd.Add("@where", str);
                dd.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeSupply<CKView> fenYe = new FenYeSupply<CKView>();
                fenYe.List = await con.QueryAsync<CKView>(sql, dd);
                fenYe.Rows = dd.Get<int>("rows");
                return fenYe;
            }
        }
        /// <summary>
        /// 添加仓库管理
        /// </summary>
        /// <param name="code">仓库编号</param>
        /// <param name="cap">容量</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">地址</param>
        /// <param name="mr">是否默认</param>
        /// <param name="sd">仓库锁定</param>
        /// <param name="man">主管</param>
        /// <param name="px">排序</param>
        /// <param name="cz">操作人</param>
        /// <param name="gx">更新人</param>
        /// <param name="name">名称</param>
        /// <param name="bz">备注</param>
        /// <param name="dh">电话</param>
        /// <returns></returns>
        public async Task<bool> InsertHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string cz, string gx, string name, string bz, string dh)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"insert into Bs_warehouse(ware_code, ware_cap, ware_state, ware_adr, is_default, is_lock, ware_duty_man, sort_code, create_by, update_by, is_del, ware_name, remark, dh) values('{code}','{cap}','{zt}','{adr}','{mr}','{sd}','{man}','{px}','{cz}','{gx}','0','{name}','{bz}','{dh}')";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 仓库管理批量删除
        /// </summary>
        /// <param name="num">数组</param>
        /// <returns></returns>
        public async Task<bool> PLDeleteHouse(int[] num)
        {
            for (int i = 0; i < num.Length; i++)
            {
                var ee = myContext.bs_Warehouses.Find(num[i]);
                ee.is_del = "1";
                myContext.bs_Warehouses.Update(ee);
                await myContext.SaveChangesAsync();
            }
            return true;
        }
        /// <summary>
        /// 名称是否存在
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public async Task<int> SelectAreaSLAsync(string name)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select COUNT(0) from Bs_ware_area where warehouse_id = '{name}'";
                return await con.ExecuteScalarAsync<int>(sql);
            }
        }
        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public async Task<Bs_warehouse> SelectIDAsync(int id)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from Bs_warehouse where warehouse_id = '{id}'";
                return await con.QueryFirstAsync<Bs_warehouse>(sql);
            }
        }
        /// <summary>
        /// 名称是否存在
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public async Task<int> SelectNameAsync(string name)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select COUNT(0) from Bs_warehouse where ware_name = '{name}'";
                return await con.ExecuteScalarAsync<int>(sql);
            }
        }
        /// <summary>
        /// 修改仓库管理
        /// </summary>
        /// <param name="code">编号</param>
        /// <param name="cap">容量</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">地址</param>
        /// <param name="mr">默认</param>
        /// <param name="sd">锁定</param>
        /// <param name="man">主管</param>
        /// <param name="px">排序</param>
        /// <param name="gx">更新</param>
        /// <param name="name">名称</param>
        /// <param name="bz">备注</param>
        /// <param name="dh">电话</param>
        /// <param name="id">id</param>
        /// <returns></returns>
        public async Task<bool> UpdateHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string gx, string name, string bz, string dh, int id)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"update Bs_warehouse set ware_code = '{code}',ware_cap = '{cap}',ware_state = '{zt}',ware_adr = '{adr}',is_default = '{mr}',is_lock = '{sd}',ware_duty_man = '{man}',sort_code = '{px}',update_by = '{gx}',ware_name = '{name}',remark = '{bz}',dh = '{dh}' where warehouse_id = '{id}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        /// <summary>
        /// 修改锁定状态
        /// </summary>
        /// <returns></returns>
        public async Task<bool> UpdateSDAsync()
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"update Bs_warehouse set ware_state = '2' where is_lock = '1'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }
        public async Task<CKView> SelectCodeAsync(string id)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from CKView where ware_name = '{id}'";
                return await con.QueryFirstAsync<CKView>(sql);
            }
        }
        public async Task<bool> PLQiHouse(int[] num)
        {
            for(int i = 0; i < num.Length; i++)
            {
                var ww = myContext.bs_wa.Find(num[i]);
                ww.area_state = "0";
                myContext.bs_wa.Update(ww);
                await myContext.SaveChangesAsync();
            }
            return true;
        }
        public async Task<bool> PLTingHouse(int[] num)
        {
            for (int i = 0; i < num.Length; i++)
            {
                var ww = myContext.bs_wa.Find(num[i]);
                ww.area_state = "1";
                myContext.bs_wa.Update(ww);
                await myContext.SaveChangesAsync();
            }
            return true;
        }
    }
}
