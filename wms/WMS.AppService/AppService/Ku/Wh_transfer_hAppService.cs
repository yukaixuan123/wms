using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Repository.Ku;

namespace WMS.AppService.AppService.Ku
{
    /// <summary>
    /// 调拨
    /// </summary>
    public class Wh_transfer_hAppService: IWh_transfer_hAppService
    {
        private readonly IWh_transfer_hRepository hh;

        public Wh_transfer_hAppService(IWh_transfer_hRepository hh)
        {
            this.hh = hh;

        }
        //添加盘点

        public async Task<bool> InsertWh_transfer_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx)
        {
            return await hh.InsertWh_transfer_hAsync(arrayList, xx);
        }
        //库存调拨分页
        public async Task<Fen<ST33>> FenYE(int pageSize, int currentPage, string str)
        {
            return await hh.FenYE(pageSize, currentPage, str);
        }
        //详细信息
        public async Task<Wh_transfer_h> Wh_transfer_hMHAsync(string bh)
        {
            return await hh.Wh_transfer_hMHAsync(bh);
        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Wh_transfer_dXX>> Wh_transfer_dMHAsync(string bh)
        {
            return await hh.Wh_transfer_dMHAsync(bh);
        }
        //修改调拨

        public async Task<bool> UpdateWh_transfer_hAsync(ArrayList arrayList, List<Wh_transfer_dXX> xx)
        {
            return await hh.UpdateWh_transfer_hAsync((ArrayList)arrayList, xx);
        }
        //审核
        public async Task<bool> Wh_transfer_hSHAsync(int zt, string name, string desc, string ii)
        {
            return await hh.Wh_transfer_hSHAsync(zt, name, desc, ii);
        }
        //删除调拨信息
        public async Task<bool> DeleteWh_transfer_hAsync(string dto)
        {
            return await hh.DeleteWh_transfer_hAsync((dto));
        }
        //批量删除调拨信息
        public async Task<bool> DeleteSWh_transfer_hAsync(int[] sz)
        {
            return await hh.DeleteSWh_transfer_hAsync(sz);
        }
        //库存查询分页
        public async Task<Fen<Inventory>> KuFen(int pageSize, int currentPage, string str)
        {
            return await hh.KuFen(pageSize, currentPage, str);
        }
        //单位
        public Task<List<string>> DW()
        {
            return hh.DW();
        }
        //类型
        public Task<List<string>> LX()
        {
            return hh.LX(); 
        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<List<Inventory>> KCXXAsync(string bh)
        {
            return await hh.KCXXAsync(bh);
        }
        //出入库类型
        public async Task<List<string>> CRLX()
        {
            return await hh.CRLX();
        }
        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public async Task<Inventory> KCXAsync(string bh)
        {
            return await hh.KCXAsync(bh);
        }
        //库存流水分页
        public async Task<Fen<LIU>> LiuFen(int pageSize, int currentPage, string str)
        {
            return await hh.LiuFen(pageSize, currentPage, str);
        }
    }
}
