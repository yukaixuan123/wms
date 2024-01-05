using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;

namespace WMS.Domain.Repository.Bs
{
    public interface IBs_warehouseRepository
    {
        Task<bool> Bs_warehouseAdd(Bs_warehouse bs_Warehouse);
        Task<int> Bs_warehouseDel(Bs_warehouse bs_Warehouse);
        Task<List<Bs_warehouse>> Bs_warehouseSelect();
        Task<bool> Bs_warehouseUpdate(Bs_warehouse bs_Warehouse);
        IEnumerable<Bs_warehouse> Bs_warehouseFenYe(int page, int size);
        IEnumerable<Bs_warehouse> Bs_WarehousesMH(string bh, string zt, string zg);
        FenYe<Bs_warehouse> Bs_WarehouseFYMH(int page, int size, string bh, string zt, string zg);
        Task<bool> Bs_WarehouseRKDel(int id, string del);
        /// <summary>
        /// 所有的仓库
        /// </summary>
        /// <returns></returns>
        public Task<List<Bs_warehouse>> Bs_warehouseSelect1();

        Task<FenYeSupply<CKView>> FenYeHouseAsync(int currentPage, int pageSize, string str);
        Task<int> SelectAreaSLAsync(string name);
        Task<bool> InsertHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string cz, string gx, string name, string bz, string dh);
        Task<int> SelectNameAsync(string name);
        Task<bool> UpdateSDAsync();
        Task<Bs_warehouse> SelectIDAsync(int id);
        Task<bool> UpdateHouseAsync(string code, string cap, string zt, string adr, string mr, int sd, string man, string px, string gx, string name, string bz, string dh, int id);
        Task<bool> DeleteHouseAsync(int id, string str);
        Task<bool> PLDeleteHouse(int[] num);
        Task<CKView> SelectCodeAsync(string id);
        Task<bool> PLQiHouse(int[] num);
        Task<bool> PLTingHouse(int[] num);
    }
}
