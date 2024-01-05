using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.AppService.Dtos.Bs;
using WMS.AppService.Dtos.Users;
using WMS.Domain.Entity.Bs;
using WMS.Domain.Entity.User;

namespace WMS.AppService.Profiles
{
    public class UsersProfiles:Profile
    {
        public UsersProfiles()
        {
            CreateMap<FindUsersDto,Users>().ReverseMap();
            CreateMap<UpdateUsersStateDto,Users>().ReverseMap();

        }
    }
}
