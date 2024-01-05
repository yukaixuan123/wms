using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Cm;
using WMS.AppService.Dtos.Roles;
using WMS.Domain.Entity;
using WMS.Domain.Entity.Cm;
using WMS.Domain.Entity.User;
using WMS.Domain.Repository;
using WMS.Domain.Repository.Cm;
using WMS.Domain.Repository.Sys;

namespace WMS.AppService.AppService
{
    public class RolesAppService : IRolesAppService
    {

        private readonly IRolesRepository sys;

        private readonly IMapper mapper;

        public RolesAppService(IRolesRepository sys, IMapper mapper)
        {
            this.sys = sys;
            this.mapper = mapper;
        }

        public async Task<bool> AddAuthority(AddAuthorityDto addAuthorityDto)
        {
            //Student student = mapper.Map<Student>(addStudentDto);
            //return studentRepository.AddStudent(student);
            Authority authority = mapper.Map<Authority>(addAuthorityDto);

            return await sys.AddAuthority(authority);
        }

        public async Task<bool> AddRoles(AddRolesDto addRolesDto)
        {
          Roles roles = mapper.Map<Roles>(addRolesDto);
            return await sys.AddRoles(roles);
        }

        public Task<IEnumerable<AuthorityCascader>> AuthorityGetCascader()
        {
            return sys.AuthorityGetCascader();
        }

        public async Task<bool> DeleteAuthority(int aid)
        {
            return await sys.DeleteAuthority(aid);
        }

        public async Task<bool> DeleteRoles(int roleId)
        {
          return await sys.DeleteRoles(roleId);
        }

        public FenYe<Roles> Find(int page, int pageSize, string gw, string zt)
        {
            return sys.Find(page,pageSize,gw,zt);
        }

        public Task<FenYeUsers<Authority>> FindAuthority(int pageSize, int CurrentPage, string str)
        {
          return sys.FindAuthority(pageSize,CurrentPage,str);
        }

        public List<Roles> FindRoles()
        {
           return sys.FindRoles();
        }

        public int[] GetQuan(int RolesID)
        {
           return sys.GetQuan(RolesID);
        }

        public List<RolesAuthority> GetRolesId(int RolesID)
        {
          return sys.GetRolesId(RolesID);
        }

        public Task<IEnumerable<Trees>> GetTrees()
        {
            return sys.GetTrees();
        }

        public async Task<bool> RemoveRoles(int roleId)
        {
            return await sys.RemoveRoles(roleId);
        }

        public async Task<bool> UpdateAuthority(UpdateAuthorityDto updateAuthorityDto)
        {
           Authority authority =mapper.Map<Authority>(updateAuthorityDto);
            return await sys.UpdateAuthority(authority);
        }

        public async Task<bool> UpdateRoles(int roleId, int pid)
        {
           return await sys.UpdateRoles(roleId, pid);
        }

        public async Task<bool> UpdateRolesState(int roleId, string u_State)
        {
            return await sys.UpdateRolesState(roleId, u_State);
        }
    }
}
