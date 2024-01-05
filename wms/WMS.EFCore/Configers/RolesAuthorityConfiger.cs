using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WMS.Domain.Entity.User;

namespace WMS.EFCore.Configers
{
    /// <summary>
    /// 角色权限
    /// </summary>
    internal class RolesAuthorityConfiger : IEntityTypeConfiguration<RolesAuthority>
    {
        public void Configure(EntityTypeBuilder<RolesAuthority> builder)
        {
            builder.ToTable(nameof(RolesAuthority));
            builder.HasKey(e => e.RolesAuthorityID);
            builder.Property(e => e.RolesID).IsRequired().HasColumnType("int");
            builder.Property(e => e.AuthorityID).IsRequired().HasColumnType("int");
        }
    }
}
