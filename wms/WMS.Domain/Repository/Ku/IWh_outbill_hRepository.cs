using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Shi;
using WMS.Domain.Entity.Sup;

namespace WMS.Domain.Repository.Ku
{
    /// <summary>
    /// 出库管理
    /// </summary>
    public interface IWh_outbill_hRepository
    {
        //客户
        public Task<List<Bs_customer>> Bs_customerFind();
        //根据名字找客户
        public Task<Bs_customer> Bs_customerName(string name);

        /// <summary>
        /// 有库存的仓库
        /// </summary>
        /// <returns></returns>
        public  Task<List<string>> Ku(int id);

        /// <summary>
        /// 有库存的货品
        /// </summary>
        /// <returns></returns>
        public  Task<string[]> Hp(string ck);

        public  Task<List<string>> Ku1();

        /// <summary>
        /// 对应货品的库存
        /// </summary>
        /// <param name="hp"></param>
        /// <param name="kw"></param>
        /// <returns></returns>
        public  Task<Wh_now_storage> Num(string hp, string kw);

        //添加出库(没有关联订单)

        public Task<bool> Insert1Wh_outbill_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx);
        //添加出库(有关联订单)

        public  Task<bool> InsertWh_outbill_hAsync(ArrayList arrayList, List<Wh_sale_dXX> xx);
        //出库管理分页
        public  Task<Fen<ST11>> FenYE(int pageSize, int currentPage, string str);

        //销售订单分页
        public  Task<Fen<View_Sale>> Wh_sale_hFenYeAsync(int pageSize, int currentPage, string str);

        /// <summary>
        /// 详细详细
        /// </summary>
        /// <param name="bh"></param>
        /// <returns></returns>
        public  Task<List<Wh_outbill_dXX>> Wh_outbill_dMHAsync(string bh);

        //详细信息
        public Task<Wh_outbill_h> Wh_outbill_hMHAsync(string bh);
        /// <summary>
        /// 销售订单详细
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public  Task<List<Wh_sale_dXX>> Wh_sale_BH(string str);

        //修改出库(没有关联订单)

        public Task<bool> Update1Wh_outbill_hAsync(ArrayList arrayList, List<Wh_outbill_dXX> xx);

        //修改出库(有关联订单)

        public  Task<bool> Update2Wh_outbill_hAsync(ArrayList arrayList, List<Wh_outbill_dXX> xx);

        //审核
        public Task<bool> Wh_outbill_hSHAsync(int zt, string name, string desc, string ii);

        //改变库存
        public  Task<bool> Wh_now_storageAsync(string dh);

        //删除出库信息
        public  Task<bool> DeleteWh_outbill_hAsync(string dto);

        //批量删除出库信息
        public  Task<bool> DeleteSWh_outbill_hAsync(int[] sz);

        /// <summary>
        /// 根据名字找仓库
        /// </summary>
        /// <returns></returns>
        public Task<Bs_warehouse> Bs_warehouseName(string name);
    }
}
