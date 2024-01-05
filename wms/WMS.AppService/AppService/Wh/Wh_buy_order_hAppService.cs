using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Ku;
using WMS.Domain.Repository.Wh;

namespace WMS.AppService.AppService.Wh
{
    public class Wh_buy_order_hAppService : IWh_buy_order_hAppService
    {
        private readonly IWh_buy_order_hRepository or;
        private readonly IMapper mapper;
        public Wh_buy_order_hAppService(IWh_buy_order_hRepository or, IMapper mapper)
        {
            this.or = or;
            this.mapper = mapper;
        }


        /// <summary>
        /// 货品信息
        /// </summary>
        /// <param name="pageSize"></param>
        /// <param name="currentPage"></param>
        /// <param name="str"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<FenYeDapper<View_Bs_Item>> Bs_item_FenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Bs_item_FenYeAsync(pageSize,currentPage,str);
        }

        /// <summary>
        /// 供应商信息
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<List<Bs_supply>> SuplyFind()
        {
            return or.SuplyFind();
        }
        /// <summary>
        /// 根据名字查供应商
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<Bs_supply> SuplyFindName(string name)
        {
            return or.SuplyFindName(name);
        }

        /// <summary>
        /// 用户信息
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<List<Users>> UserFind()
        {
            return or.UserFind();

        }

        public Task<Users> UsersID(string username, string password)
        {
            return or.UsersID(username, password);
        }

        /// <summary>
        /// 进货订单查询
        /// </summary>
        /// <param name="fenYe"></param>
        /// <returns></returns>
        public Task<FenYeDapper<View_Order>> Wh_buy_order_hFenYeAsync(int pageSize, int currentPage, string str)
        {
            return or.Wh_buy_order_hFenYeAsync(pageSize,currentPage,str);
        }

        public Task<bool> Wh_buy_order_h_chexiaoAsync(string sure_man, int buy_codeId)
        {
            return or.Wh_buy_order_h_chexiaoAsync(sure_man, buy_codeId);
        }

        public Task<IEnumerable<Wh_orderbuy_d>> Wh_buy_order_h_Code1Asyunc(string buy_code)
        {
            return or.Wh_buy_order_h_Code1Asyunc(buy_code);
        }

        public Task<IEnumerable<ST1>> Wh_buy_order_h_Code2Asyunc(string buy_code)
        {
            return or.Wh_buy_order_h_Code2Asyunc(buy_code);
        }

        /// <summary>
        /// 根据单号查进货订单
        /// </summary>
        /// <param name="buy_code"></param>
        /// <returns></returns>
        public Task<View_Order> Wh_buy_order_h_CodeAsyunc(string buy_code)
        {
            return or.Wh_buy_order_h_CodeAsyunc(buy_code);
        }

        /// <summary>
        /// 进货订单批量删除
        /// </summary>
        /// <param name="carModel"></param>
        /// <returns></returns>
        public Task<bool> Wh_buy_order_h_DeleteArryAsync(int[] carModel)
        {
            return or.Wh_buy_order_h_DeleteArryAsync(carModel);
        }
        /// <summary>
        /// 进货订单删除
        /// </summary>
        /// <param name="buy_codeId"></param>
        /// <returns></returns>
        public Task<bool> Wh_buy_order_h_DeleteAsync(int buy_codeId)
        {
            return or.Wh_buy_order_h_DeleteAsync(buy_codeId);
        }

        /// <summary>
        /// 进货订单添加
        /// </summary>
        /// <param name="sg"></param>
        /// <param name="gg"></param>
        /// <returns></returns>
        public Task<bool> Wh_buy_order_h_InsertAsync(List<Wh_orderbuy_d> dd, Wh_buy_order_h h)
        {
            return or.Wh_buy_order_h_InsertAsync(dd, h);
        }

        public Task<bool> Wh_buy_order_h_sale_stateAsync(string sale_state, string sure_man, int buy_codeId, string sale_state_yj)
        {
            return or.Wh_buy_order_h_sale_stateAsync(sale_state,sure_man,buy_codeId,sale_state_yj);
        }
        /// <summary>
        /// 进货订单修改
        /// </summary>
        /// <param name="dd"></param>
        /// <param name="h"></param>
        /// <returns></returns>
        public Task<bool> Wh_buy_order_h_UpdateAsync(List<Wh_orderbuy_d> dd, Wh_buy_order_h h)
        {
            return or.Wh_buy_order_h_UpdateAsync(dd,h);
        }
    }
}
