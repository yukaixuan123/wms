using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Bs;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity;

namespace WMS.AppService.AppService.Bs
{
    //进行增删改查操作
    public interface IBs_ware_areaAppService
    {
        
        Task<List<Bs_ware_area>> Bs_ware_areaSelect();
        IEnumerable<Bs_ware_area> Bs_ware_areaFenYe(int page, int size);
        Task<bool> Bs_ware_areaRKDel(int id, string del);
        Task<bool> Bs_ware_areaAdd(AddBs_ware_areaDto addBs_ware_areaDto);
        Task<int> Bs_ware_areaDel(DelBs_ware_areaDto delBs_ware_areaDto);
        Task<bool> Bs_ware_areaUpdate(UpdateBs_ware_areaDto updateBs_ware_areaDto);

        Task<FenYeSupply<Bs_ware_area>> FenYeWareAreaAsync(int currentPage, int pageSize, string str);
        Task<bool> InsertAreaAsync(string code, string name, string cap, string man, int px, int zt, string cz, string gx, string bz, string dh,string cc);
        Task<Bs_ware_area> SelectIDAsync(int id);
        Task<bool> UpdateAreaAsync(string code, string name, string cap, string man, string px, string zt, string gx, string bz, string dh, string id,string cc);
        Task<int> AreaNameAsync(string name);
        Task<bool> AreaDeleteAsync(int id, string str);
        Task<bool> PLDeleteArea(int[] num);
    }
}
