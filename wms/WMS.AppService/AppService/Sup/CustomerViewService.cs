using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Sup;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository.Sup;

namespace WMS.AppService.AppService.Sup
{
    public class CustomerViewService : ICustomerViewService
    {
        private readonly ICustomerViewRepository customerViewRepository;
        private readonly IMapper mapper;
        public CustomerViewService(ICustomerViewRepository customerViewRepository, IMapper mapper)
        {
            this.customerViewRepository = customerViewRepository;
            this.mapper = mapper;
        }
        /// <summary>
        /// 客户管理逻辑删除
        /// </summary>
        /// <param name="id">客户id</param>
        /// <param name="str">条件</param>
        /// <returns></returns>
        public Task<bool> CustomerDeleteAsync(int id, string str)
        {
            return customerViewRepository.CustomerDeleteAsync(id, str);
        }
        /// <summary>
        /// 客户管理添加
        /// </summary>
        /// <param name="code">客户编码</param>
        /// <param name="name">客户名称</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="adr">客户地址</param>
        /// <param name="zt">状态</param>
        /// <param name="from">客户来源</param>
        /// <param name="fz">销售负责人</param>
        /// <param name="type">所属行业</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <returns></returns>
        public Task<bool> CustomerInsertAsync(string code, string name, string man, string tel, string yx, string adr, string zt, string from, string fz, string type, string cz, string bz)
        {
            return customerViewRepository.CustomerInsertAsync(code,name,man,tel,yx,adr,zt,from,fz,type,cz,bz);
        }
        /// <summary>
        /// 客户名称是否存在
        /// </summary>
        /// <param name="name">客户名称</param>
        /// <returns></returns>
        public Task<int> CustomerNameAsync(string name)
        {
            return customerViewRepository.CustomerNameAsync(name);
        }
        /// <summary>
        /// 客户管理修改
        /// </summary>
        /// <param name="code">客户编码</param>
        /// <param name="name">客户名称</param>
        /// <param name="type">所属行业</param>
        /// <param name="from">客户来源</param>
        /// <param name="man">联系人</param>
        /// <param name="tel">联系电话</param>
        /// <param name="yx">邮箱</param>
        /// <param name="fz">销售负责人</param>
        /// <param name="zt">状态</param>
        /// <param name="adr">地址</param>
        /// <param name="cz">操作人</param>
        /// <param name="bz">备注</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public Task<bool> CustomerUpdateAsync(string code, string name, string type, string from, string man, string tel, string yx, string fz, string zt, string adr, string cz, string bz, int id)
        {
            return customerViewRepository.CustomerUpdateAsync(code,name, type, from, man,tel, yx, fz,zt, adr, cz, bz, id);
        }

        /// <summary>
        /// 客户管理分页查询
        /// </summary>
        /// <param name="page">总页数</param>
        /// <param name="pageSize">总条数</param>
        /// <param name="str">查询条件</param>
        /// <returns></returns>
        public Task<FenYeSupply<CustomerView>> FenYeCustomerAsync(int page, int pageSize, string str)
        {
            return customerViewRepository.FenYeCustomerAsync(page, pageSize, str);
        }

        public Task<FenYeSupply<khCK>> FenYekhCKAsync(int currentPage, int pageSize, string str)
        {
            return customerViewRepository.FenYekhCKAsync(currentPage, pageSize, str);
        }

        /// <summary>
        /// 银行添加
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <returns></returns>
        public Task<bool> FinanceInsertAsync(Bs_finance bs_Finance)
        {
            return customerViewRepository.FinanceInsertAsync(bs_Finance);
        }
        /// <summary>
        /// 银行修改
        /// </summary>
        /// <param name="bs_Finance">银行实体类</param>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public Task<bool> FinanceUpdateAsync(Bs_finance bs_Finance, int id)
        {
            return customerViewRepository.FinanceUpdateAsync(bs_Finance, id);
        }
        /// <summary>
        /// 所属行业下拉框
        /// </summary>
        /// <returns></returns>
        public Task<IEnumerable<Bs_customer>> HYAsync()
        {
            return customerViewRepository.HYAsync();
        }
        /// <summary>
        /// 客户来源下拉框
        /// </summary>
        /// <returns></returns>
        public Task<IEnumerable<Bs_customer>> LYAsync()
        {
            return customerViewRepository.LYAsync();
        }

        /// <summary>
        /// 客户管理批量删除
        /// </summary>
        /// <param name="num">数组</param>
        /// <returns></returns>
        public Task<bool> PLDeleteCustomer(int[] num)
        {
            return customerViewRepository.PLDeleteCustomer(num);
        }

        public Task<CustomerView> SelectCodeAsync(string id)
        {
            return customerViewRepository.SelectCodeAsync(id);
        }

        /// <summary>
        /// 根据id查全部
        /// </summary>
        /// <param name="id">客户id</param>
        /// <returns></returns>
        public Task<CustomerView> SelectIDAsync(int id)
        {
            return customerViewRepository.SelectIDAsync(id);
        }

        /// <summary>
        /// 当前用户
        /// </summary>
        /// <param name="username">用户名</param>
        /// <param name="password">密码</param>
        /// <returns></returns>
        public Task<Users> UsersID(string username, string password)
        {
            return customerViewRepository.UsersID(username, password);
        }
    }
}
