using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.KC;
using WMS.Domain.Entity.Wh;
using WMS.Domain.Repository.Wh;

namespace WMS.AppService.AppService.Wh
{
    public class HomeAppService: IHomeAppService
    {
        private readonly IHomeRepository or;
        private readonly IMapper mapper;
        public HomeAppService(IHomeRepository or, IMapper mapper)
        {
            this.or = or;
            this.mapper = mapper;
        }
        /// <summary>
        /// 全部待出库
        /// </summary>
        /// <returns></returns>
        public int ALLckAsync()
        {
            return or.ALLckAsync();
        }

        /// <summary>
        /// 全部待审核
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Alldsh>> ALLdskAsync()
        {
            return or.ALLdskAsync();
        }
        /// <summary>
        /// 全部待入库
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public int ALLrkAsync()
        {
            return or.ALLrkAsync();
        }

        /// <summary>
        /// 出库排名
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<PaiMing>> CKpaimingAsync()
        {
            return or.CKpaimingAsync();
        }

        /// <summary>
        /// 出库统计
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<ST2>> HomeCKAsync()
        {
            return or.HomeCKAsync();
        }
        /// <summary>
        /// 库存货品数量占比
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Wh_now_storage1>> HomeHPSLAsync()
        {
            return or.HomeHPSLAsync();
        }

        /// <summary>
        /// 入库统计
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<ST1>> HomeRKAsync()
        {
            return or.HomeRKAsync();
        }
        /// <summary>
        /// 库存数量占比
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<Wh_now_storage>> HomeSLAsync()
        {
            return or.HomeSLAsync();
        }

        public int hpslSUM()
        {
            return or.hpslSUM();
        }

        public int kcslSUM()
        {
            return or.kcslSUM();
        }
        /// <summary>
        /// 入库排名
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<IEnumerable<PaiMing>> RKpaimingAsync()
        {
            return or.RKpaimingAsync();
        }

        /// <summary>
        /// 出库今
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<ToYesCount> ToCountCKAsync()
        {
            return or.ToCountCKAsync();
        }

        /// <summary>
        /// 入库今
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<ToYesCount> ToCountRKAsync()
        {
            return or.ToCountRKAsync();
        }

        /// <summary>
        /// 出库昨
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<ToYesCount> YesCountCKAsync()
        {
            return or.YesCountCKAsync();
        }

        /// <summary>
        /// 入库昨
        /// </summary>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public Task<ToYesCount> YesCountRKAsync()
        {
            return or.YesCountRKAsync();
        }
    }
}
