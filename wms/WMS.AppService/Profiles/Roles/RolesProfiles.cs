using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Ku;
using WMS.AppService.Dtos.Roles;
using WMS.AppService.Dtos.Sys;
using WMS.AppService.Profiles.Sys;
using WMS.Domain.Entity.Ku;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.User;

namespace WMS.AppService.Profiles
{
    public class RolesProfiles: Profile
    {
        public RolesProfiles()
        {            
              CreateMap<AddAuthorityDto, Authority>().ReverseMap();
            CreateMap<UpdateAuthorityDto, Authority>().ReverseMap();
            CreateMap<DeleteAuthorityDto, Authority>().ReverseMap();
            CreateMap<AddRolesDto, Roles>().ReverseMap();


        }
    }
}
