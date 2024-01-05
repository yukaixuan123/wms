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
    public class Bs_ware_areaRepository : IBs_ware_areaRepository
    {
        private readonly MyContext myContext;
        public Bs_ware_areaRepository(MyContext myContext)
        {
            this.myContext = myContext;
        }

        public async Task<bool> Bs_ware_areaAdd(Bs_ware_area bs_Ware_Area)
        {
            myContext.bs_wa.Add(bs_Ware_Area);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        public async Task<int> Bs_ware_areaDel(Bs_ware_area bs_Ware_Area)
        {
            myContext.bs_wa.Remove(bs_Ware_Area);
            return await myContext.SaveChangesAsync();
        }

        public Task<List<Bs_ware_area>> Bs_ware_areaSelect()
        {
            return myContext.bs_wa.ToListAsync();
        }

        public async Task<bool> Bs_ware_areaUpdate(Bs_ware_area bs_Ware_Area)
        {
            myContext.bs_wa.Update(bs_Ware_Area);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        //分页
        public IEnumerable<Bs_ware_area> Bs_ware_areaFenYe(int page, int size)
        {
            return myContext.bs_wa.Skip((page - 1) * size).Take(size).ToList();
        }

        //删除入库信息
        public async Task<bool> Bs_ware_areaRKDel(int id, string del)
        {
            var entity = myContext.bs_wa.Find(id);
            entity.is_del = del;
            myContext.bs_wa.Update(entity);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }
        string constr = "Data Source=8.134.157.208,2568;Initial Catalog=WMS_modern;User ID=sa;Password=123456;Encrypt=False;";
        public async Task<FenYeSupply<Bs_ware_area>> FenYeWareAreaAsync(int currentPage, int pageSize, string str)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                DynamicParameters dd = new DynamicParameters();
                dd.Add("@pageSize", pageSize);
                dd.Add("@keyName", "ware_area_id");
                dd.Add("@tableName", "Bs_ware_area");
                dd.Add("@currentPage", currentPage);
                dd.Add("@where", str);
                dd.Add("@rows", direction: ParameterDirection.Output, dbType: DbType.Int32);
                string sql = "exec [dbo].[procFenYe_Where] @pageSize, @keyName, @tableName, @currentPage, @where, @rows out";
                FenYeSupply<Bs_ware_area> fenYe = new FenYeSupply<Bs_ware_area>();
                fenYe.List = await con.QueryAsync<Bs_ware_area>(sql, dd);
                fenYe.Rows = dd.Get<int>("rows");
                return fenYe;
            }
        }

        public async Task<bool> InsertAreaAsync(string code, string name, string cap, string man, int px, int zt, string cz, string gx, string bz, string dh,string cc)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"insert into Bs_ware_area(area_code, area_name, area_cap, area_duty_man, sort_code, area_state, create_by, update_by, is_del, remark, dh,warehouse_id) values('{code}','{name}','{cap}','{man}','{px}','{zt}','{cz}','{gx}','0','{bz}','{dh}','{cc}')";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<Bs_ware_area> SelectIDAsync(int id)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select * from Bs_ware_area where ware_area_id = '{id}'";
                return await con.QueryFirstAsync<Bs_ware_area>(sql);
            }
        }

        public async Task<bool> UpdateAreaAsync(string code, string name, string cap, string man, string px, string zt, string gx, string bz, string dh, string id,string cc)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"update Bs_ware_area set area_code = '{code}',area_name = '{name}',area_cap = '{cap}',area_duty_man = '{man}',sort_code = '{px}',area_state = '{zt}',update_by = '{gx}',remark = '{bz}',dh = '{dh}',warehouse_id = '{cc}' where ware_area_id = '{id}'";
                return await con.ExecuteAsync(sql) > 0 ? true : false;
            }
        }

        public async Task<int> AreaNameAsync(string name)
        {
            using (SqlConnection con = new SqlConnection(constr))
            {
                string sql = $@"select COUNT(0) from Bs_ware_area where area_name = '{name}'";
                return await con.ExecuteScalarAsync<int>(sql);
            }
        }

        public async Task<bool> AreaDeleteAsync(int id, string str)
        {
            var ee = myContext.bs_Ware_Areas.Find(id);
            ee.is_del = str;
            myContext.bs_Ware_Areas.Update(ee);
            return await myContext.SaveChangesAsync() > 0 ? true : false;
        }

        public async Task<bool> PLDeleteArea(int[] num)
        {
            for (int i = 0; i < num.Length; i++)
            {
                var ee = myContext.bs_wa.Find(num[i]);
                ee.is_del = "1";
                myContext.bs_wa.Update(ee);
                await myContext.SaveChangesAsync();
            }
            return true;
        }
        
    }
}
