using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity;

namespace WMS.Domain.Repository.Bs
{
    public interface IBs_ware_areaRepository
    {
        Task<bool> Bs_ware_areaAdd(Bs_ware_area bs_Ware_Area);
        Task<int> Bs_ware_areaDel(Bs_ware_area bs_Ware_Area);
        Task<List<Bs_ware_area>> Bs_ware_areaSelect();
        Task<bool> Bs_ware_areaUpdate(Bs_ware_area bs_Ware_Area);
        IEnumerable<Bs_ware_area> Bs_ware_areaFenYe(int page, int size);
        Task<bool> Bs_ware_areaRKDel(int id, string del);
        Task<FenYeSupply<Bs_ware_area>> FenYeWareAreaAsync(int currentPage, int pageSize, string str);
        Task<bool> InsertAreaAsync(string code, string name, string cap, string man, int px, int zt, string cz, string gx, string bz, string dh,string cc);
        Task<Bs_ware_area> SelectIDAsync(int id);
        Task<bool> UpdateAreaAsync(string code, string name, string cap, string man, string px, string zt, string gx, string bz, string dh, string id,string cc);
        Task<int> AreaNameAsync(string name);
        Task<bool> AreaDeleteAsync(int id, string str);
        Task<bool> PLDeleteArea(int[] num);
    }
}
