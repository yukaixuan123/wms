using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Cm;
using WMS.Domain.Repository.Sup;

namespace WMS.AppService.AppService.Sup
{
    public class SupplyViewService : ISupplyViewService
    {
        private readonly ISupplyViewRepository supplyViewRepository;
        private readonly IMapper mapper;
        public SupplyViewService(ISupplyViewRepository supplyViewRepository, IMapper mapper)
        {
            this.supplyViewRepository = supplyViewRepository;
            this.mapper = mapper;
        }
        /// <summary>
        /// 供应商管理分页查询
        /// </summary>
        /// <param name="currentPage">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="str">查询条件</param>
        /// <returns></returns>
        public Task<FenYeSupply<SupplyView>> FenYeAsync(int currentPage, int pageSize, string str)
        {
            return supplyViewRepository.FenYeAsync(currentPage, pageSize, str);
        }
        /// <summary>
        /// 银行添加
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <returns></returns>
        public Task<bool> FinanceInsertAsync(Bs_finance bs_Finance)
        {
            return supplyViewRepository.FinanceInsertAsync(bs_Finance);
        }
        /// <summary>
        /// 银行修改
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance, int id)
        {
            return supplyViewRepository.FinanceUpdateAsync(bs_Finance, id);
        }

        /// <summary>
        /// 供应商分类下拉框
        /// </summary>
        /// <returns></returns>
        public Task<IEnumerable<Bs_supply>> FLAsync()
        {
            return supplyViewRepository.FLAsync();
        }
        /// <summary>
        /// 所属行业下拉框
        /// </summary>
        /// <returns></returns>
        public Task<IEnumerable<Bs_supply>> HYAsync()
        {
            return supplyViewRepository.HYAsync();
        }

        /// <summary>
        /// 供应商管理批量删除
        /// </summary>
        /// <param name="num">数组</param>
        /// <returns></returns>
        public Task<bool> PLDeleteSupply(int[] num)
        {
            return supplyViewRepository.PLDeleteSupply(num);
        }

        public Task<SupplyView> SelectCodeAsync(string id)
        {
            return supplyViewRepository.SelectCodeAsync(id);
        }

        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id">供应商id</param>
        /// <returns></returns>
        public Task<SupplyView> SelectIDAsync(int id)
        {
            return supplyViewRepository.SelectIDAsync(id);
        }

        //public Task<SupXQ> SelectSupXQ(string name)
        //{
        //    return supplyViewRepository.SelectSupXQ(name);
        //}

        /// <summary>
        /// 供应商管理逻辑删除
        /// </summary>
        /// <param name="id">供应商id</param>
        /// <param name="bl">条件</param>
        /// <returns></returns>
        public Task<bool> SupplyDeleteAsync(int id, string bl)
        {
            return supplyViewRepository.SupplyDeleteAsync(id, bl);
        }
        /// <summary>
        /// 供应商管理添加
        /// </summary>
        /// <param name="bs_Supply">供应商实体类</param>
        /// <returns></returns>
        public Task<bool> SupplyInsertAsync(string code, string name, string type, string typecode, string man, string tel, string yx, string sdman, string zt, string adr, string cz, string bz)
        {
            return supplyViewRepository.SupplyInsertAsync(code,name,type,typecode,man,tel,yx,sdman,zt,adr,cz,bz);
        }
        /// <summary>
        /// 供应商名称是否存在
        /// </summary>
        /// <param name="name">供应商名称</param>
        /// <returns></returns>
        public Task<int> SupplyNameAsync(string name)
        {
            return supplyViewRepository.SupplyNameAsync(name);
        }
        /// <summary>
        /// 供应商管理修改
        /// </summary>
        /// <param name="code">供应商编码</param>
        /// <param name="name">供应商名称</param>
        /// <param name="type">所属行业</param>
        /// <param name="typecode">供应商分类</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="fz">进货负责人</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">供应商地址</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <param name="id">供应商id</param>
        /// <returns></returns>
        public Task<bool> SupplyUpdateAsync(string code, string name, string type, string typecode, string man, string tel, string yx, string fz, string zt, string adr, string cz, string bz, int id)
        {
            return supplyViewRepository.SupplyUpdateAsync(code,name,type,typecode,man,tel,yx,fz,zt,adr,cz,bz,id);
        }

        /// <summary>
        /// 当前用户
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <returns></returns>
        public Task<Users> UsersID(string username, string password)
        {
            return supplyViewRepository.UsersID(username, password);
        }
        public Task<FenYeSupply<gysRK>> FenYegysRKAsync(int page, int pageSize, string str)
        {
            return supplyViewRepository.FenYegysRKAsync(page, pageSize, str);
        }

        public Task<IEnumerable<Users>> CzrAsync()
        {
            return supplyViewRepository.CzrAsync();
        }
    }
}
