using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Sys;
using WMS.AppService.Dtos.Users;
using WMS.Domain.Entity.Sys;
using WMS.Domain.Entity.User;
using AutoMapper;

namespace WMS.AppService.Profiles.Sys
{
    public class Sys_encodeProfiles: Profile
    {
        public Sys_encodeProfiles()
        {
            CreateMap<UpdateSys_encodeDto,Sys_encode>().ReverseMap();
        }
    }
}
