using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;

namespace WMS.Domain.Repository.Ku
{
    /// <summary>
    /// 库存盘点
    /// </summary>
    public interface IWh_inventory_hRepository
    {
        //添加盘点

        public  Task<bool> InsertWh_inventory_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx);

        //库存盘点分页
        public  Task<Fen<ST22>> FenYE(int pageSize, int currentPage, string str);

        //详细信息
        public  Task<Wh_inventory_h> Wh_inventory_hMHAsync(string bh);

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public Task<List<Wh_inventory_dXX>> Wh_inventory_dMHAsync(string bh);

        //修改盘点

        public Task<bool> UpdateWh_inventory_hAsync(ArrayList arrayList, List<Wh_inventory_dXX> xx);

        //审核
        public  Task<bool> Wh_inventory_hSHAsync(int zt, string name, string desc, string ii);

        //删除调拨信息
        public  Task<bool> DeleteWh_inventory_hAsync(string dto);
        //批量删除调拨信息
        public  Task<bool> DeleteSWh_inventory_hAsync(int[] sz);
    }
}
