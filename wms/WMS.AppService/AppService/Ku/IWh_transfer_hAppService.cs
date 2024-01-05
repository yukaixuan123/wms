using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;

namespace WMS.AppService.AppService.Ku
{
    /// <summary>
    /// 调拨
    /// </summary>
    public interface IWh_transfer_hAppService
    {
        //添加盘点

        public Task<bool> InsertWh_transfer_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx);

        //库存调拨分页
        public Task<Fen<ST33>> FenYE(int pageSize, int currentPage, string str);

        //详细信息
        public Task<Wh_transfer_h> Wh_transfer_hMHAsync(string bh);

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public Task<List<Wh_transfer_dXX>> Wh_transfer_dMHAsync(string bh);

        //修改调拨

        public Task<bool> UpdateWh_transfer_hAsync(ArrayList arrayList, List<Wh_transfer_dXX> xx);

        //审核
        public Task<bool> Wh_transfer_hSHAsync(int zt, string name, string desc, string ii);

        //删除调拨信息
        public Task<bool> DeleteWh_transfer_hAsync(string dto);
        //批量删除调拨信息
        public Task<bool> DeleteSWh_transfer_hAsync(int[] sz);

        //库存查询分页
        public Task<Fen<Inventory>> KuFen(int pageSize, int currentPage, string str);

        //单位
        public Task<List<string>> DW();
        //类型
        public Task<List<string>> LX();
        //出入库类型
        public Task<List<string>> CRLX();

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public Task<List<Inventory>> KCXXAsync(string bh);

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public Task<Inventory> KCXAsync(string bh);

        //库存流水分页
        public Task<Fen<LIU>> LiuFen(int pageSize, int currentPage, string str);
    }
}
